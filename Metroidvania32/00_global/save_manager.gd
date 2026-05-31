# SaveManager script
extends Node

const SLOTS : Array[ String ] = [
	"save_01", "save_02", "save_03"
]

var current_slot : int = 0
var save_data : Dictionary
var discovered_areas : Array = []
var persistent_data : Dictionary = {}

const default_scene_uid : String = "uid://beln0e1ghjnm"

func _ready() -> void:
	SceneManager.scene_entered.connect( _on_scene_entered )
	pass
	
func _unhandled_key_input( event: InputEvent ) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_U:
			save_game()
		elif event.keycode == KEY_I:
			load_game( current_slot )
		elif event.keycode == KEY_1:
			current_slot = 0
		elif event.keycode == KEY_2:
			current_slot = 1
		elif event.keycode == KEY_3:
			current_slot = 2
	pass
	
func create_new_game_save( slot : int ) -> void:
	current_slot = slot 
	discovered_areas.clear()
	persistent_data.clear()
	var new_game_scene : String = default_scene_uid
	discovered_areas.append( new_game_scene )
	save_data = {
		"scene_path" : new_game_scene,
		"x" : 83,
		"y" : 285,
		"hp" : 100.0,
		"max_hp" : 100.0,
		# list out unlockable abilities here
		"double_jump" : false, 
		# -------------------
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
	}
	
	# Save Game Data then Load Game
	var save_file = FileAccess.open( get_file_name(current_slot), FileAccess.WRITE )
	save_file.store_line( JSON.stringify( save_data ) )
	save_file.close()
	load_game( slot )
	pass
	
func save_game() -> void:
	print("Trying to save the game...")
	var player : Player = get_tree().get_first_node_in_group( "player" )
	
	# Update Save Data
	save_data = {
		"scene_path" : SceneManager.current_scene_uid,
		"x" : player.global_position.x,
		"y" : player.global_position.y,
		"hp" : player.stats.health,
		"max_hp" : player.stats.current_max_health,
		# list out unlockable abilities here
		"double_jump" : player.double_jump, 
		# -------------------
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
	}
	# Save Game Data
	var save_file = FileAccess.open( get_file_name(current_slot), FileAccess.WRITE )
	save_file.store_line( JSON.stringify( save_data ) )
	pass
	
func load_game( slot : int ) -> void:
	print("Trying to load game at Slot: ", slot)
	if not FileAccess.file_exists( get_file_name(current_slot) ):
		return
	current_slot = slot
	
	var save_file = FileAccess.open( get_file_name(current_slot), FileAccess.READ )
	save_data = JSON.parse_string( save_file.get_line() )
	
	persistent_data = save_data.get( "persistent_data", {} )
	discovered_areas = save_data.get( "discovered_areas", [])
	var scene_path : String = save_data.get( "scene_path", default_scene_uid )
	SceneManager.transition_scene( scene_path, "", Vector2.ZERO, "up" )
	await SceneManager.new_scene_ready
	
	setup_player()
	pass
	
func setup_player() -> void:
	var player : Player = null
	while not player:
		get_tree().get_first_node_in_group( "player" )
		await get_tree().process_frame
	
	player.stats.current_max_health = save_data.get( "max_hp", 100.0 )
	player.stats.health = save_data.get( "hp", 100.0 )
	
	player.double_jump = save_data.get( "double_jump", false )
	
	player.global_position = Vector2(
		save_data.get( "x", 0 ),
		save_data.get( "y", 0 )
	)
	
	pass

func get_file_name( slot : int ) -> String:
	#"user://save.sav"
	return "user://" + SLOTS[ slot ] + ".sav"
	
func save_file_exists( slot : int ) -> bool:
	return FileAccess.file_exists( get_file_name( slot ) )
	
func is_area_discovered( scene_uid : String ) -> bool:
	return discovered_areas.has( scene_uid )
	
func _on_scene_entered( scene_uid : String ) -> void:
	if discovered_areas.has( scene_uid ):
		return
	else:
		discovered_areas.append( scene_uid )
	pass
	
