@icon( "res://general/icons/camera_2d.svg" )
extends Camera2D

@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var player_node: Player
@onready var level_bounds: LevelBounds

var level_rect: Rect2
var shake_offset: Vector2 = Vector2.ZERO

func _ready():
	CameraManager.set_active_camera(self)
	
	CameraManager.zoom_changed.connect(_on_zoom_changed)
	CameraManager.shake_requested.connect(_on_shake_requested)
	SceneManager.new_scene_ready.connect(_on_scene_transition)
	
	find_player()
	find_level_bounds()
	await get_tree().process_frame
	position_smoothing_enabled = true
	position_smoothing_speed = 7.0
	
func _process(_delta: float) -> void:	
	var target = CameraManager.current_target
	
	if !is_instance_valid(target):
		return

	update_position(target, _delta)
		
	
func update_position(target: Node2D, _delta: float):
	var target_pos = target.global_position
	
	global_position = (
		floor(target_pos / screen_size) * screen_size 
		+ screen_size / 2
	)
	
func update_shake(_delta):
	if CameraManager.shake_duration > 0.0:
		CameraManager.shake_duration -= _delta
		
		shake_offset = Vector2(
			randf_range(
				-CameraManager.shake_amount,
				CameraManager.shake_amount
			),
			randf_range(
				-CameraManager.shake_amount,
				CameraManager.shake_amount
			)
		)
	else:
		shake_offset = Vector2.ZERO
		
func _on_zoom_changed(new_zoom: Vector2):
	zoom = new_zoom
	
func _on_shake_requested(amount: float, duration: float):
	CameraManager.shake_amount = amount
	CameraManager.shake_duration = duration
	
func find_player():
	player_node = PlayerManager.player
	
func find_level_bounds():
	level_bounds = get_tree().get_first_node_in_group("level_bounds")

	if level_bounds:
		print(level_bounds.height, level_bounds.width)
		apply_level_bounds()
		
func apply_level_bounds():
	limit_left = int(level_bounds.global_position.x)
	limit_right = int(level_bounds.global_position.x) + level_bounds.width

	limit_top = int(level_bounds.global_position.y)
	limit_bottom = int(level_bounds.global_position.y) + level_bounds.height
	
func _update_camera_limits(current_camera : Camera2D, width : int, height : int) -> void:
	# Update camera's limits
	current_camera.limit_left = int(global_position.x)
	current_camera.limit_right = int(global_position.x) + width
	current_camera.limit_top = int(global_position.y) 
	current_camera.limit_bottom = int(global_position.y) + height
	
func _on_scene_transition( _t, _o ) -> void:
	reset_smoothing.call_deferred()
	pass
