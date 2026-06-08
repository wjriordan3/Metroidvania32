@tool
extends Node2D
class_name EnemySpawner

signal encounter_started
signal encounter_finished
signal wave_started(wave_index: int)
signal wave_finished(wave_index: int)

@export var encounter : Encounter
@export var spawn_points : Array[EnemySpawnPoint]
@export_tool_button("Create Spawn Point")
var create_spawn_point_action = _create_spawn_point

var _is_running := false

func start_encounter() -> void:
	if _is_running:
		return
		
	if encounter == null:
		push_warning("Enemy Spawner has no encounter assigned")
		return
		
	_is_running = true
	
	encounter_started.emit()
	
	await _run_encounter()
	
	encounter_finished.emit()
	
	_is_running = false
	
func _run_encounter() -> void:
	for index in range(encounter.waves.size()):
		var wave: Wave = encounter.waves[index]
		wave_started.emit(index)
		await _run_wave(wave)
		wave_finished.emit(index)

func _run_wave( wave : Wave ) -> void:
	var state := WaveState.new()
	
	# spawn each group. runs sequentially
	for group in wave.groups:
		await _spawn_group(group, state)
		
	# wait for all enemies in wave to be cleared
	if wave.wait_until_cleared and state.remaining > 0:
		await state.cleared
		
	if wave.delay_after_wave > 0.0:
		await get_tree().create_timer(
			wave.delay_after_wave
		).timeout
		
	pass
	
func _spawn_group(group: SpawnGroup, state : WaveState) -> void:
	if group.enemy_scene == null:
		push_warning("SpawnGroup missing enemy_scene")
		return
		
	for i in range(group.count):
		var enemy = group.enemy_scene.instantiate()
		
		var spawn_point := _get_spawn_point(group, i)
		
		if spawn_point:
			enemy.global_position = spawn_point.global_position
		else:
			enemy.global_position = global_position
			
		if enemy.has_signal("died"):
			state.register_enemy(enemy)
			
		get_tree().current_scene.add_child(enemy)
		
		# delay before sending next enemy
		if i < group.count - 1:
			await get_tree().create_timer(
				group.spawn_interval
			).timeout

func _get_spawn_point( group: SpawnGroup, index: int ) -> Node2D:
	var candidates: Array[Node2D] = []
	
	for point_name in group.spawn_point_names:
		var node = get_node_or_null(point_name)
		
		if node:
			candidates.append(node)
	
		if candidates.is_empty():
			return self
			
		if group.randomize_spawn_points:
			return candidates.pick_random()
			
		return candidates[
			index % candidates.size()
		]
		
	return candidates[0]
		
	
func _create_spawn_point():
	var marker := Marker2D.new()
	marker.name = "EnemySpawnPoint"
	add_child(marker)
	marker.owner = get_tree().edited_scene_root
