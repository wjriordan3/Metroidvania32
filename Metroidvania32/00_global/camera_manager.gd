extends Node

signal target_changed(target)
signal zoom_changed(zoom)
signal shake_requested(amount, duration)

var current_target: Node2D = null
var active_camera: Camera2D = null

var zoom_target: Vector2 = Vector2.ONE

var shake_amount: float = 0.0
var active_shake_time: float = 0.0

var shake_decay: float = 5.0

var shake_duration: float = 0.0
var shake_time_speed: float = 20.0
var noise = FastNoiseLite.new()

var transition_state: bool = false

func set_target(target: Node2D) -> void:
	if current_target == target:
		return
	
	current_target = target
	target_changed.emit(target)
	
func clear_target(target: Node2D) -> void:
	if current_target == target:
		current_target = null
		target_changed.emit(null)
		
func set_active_camera(camera: Camera2D) -> void:
	active_camera = camera

func get_active_camera() -> Camera2D:
	return CameraManager.active_camera
	
func set_zoom(value: Vector2) -> void:
	zoom_target = value
	zoom_changed.emit(value)

func screen_shake(amount: float, duration: float) -> void:
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	
	shake_amount = amount
	active_shake_time = duration
	shake_duration = duration
	
	
	shake_requested.emit(amount, duration)

func begin_transition() -> void:
	transition_state = true
	
func end_transition() -> void:
	transition_state = false	
	
func _physics_process(delta: float) -> void:
	if current_target == null:
		return
	if active_shake_time > 0:
		shake_duration += delta * shake_time_speed
		active_shake_time -= delta
		
		active_camera.offset = Vector2(
			noise.get_noise_2d(shake_duration, 0) * shake_amount,
			noise.get_noise_2d(0, shake_duration) * shake_amount	
		)
		
		shake_amount = max(shake_amount - shake_decay * delta, 0)
	else:
		if active_camera != null:
			active_camera.offset = lerp(active_camera.offset, Vector2.ZERO, 10.5 * delta)
