class_name MechaAnimController extends Node

var current_anim : StringName = "idle"

var anim_time : float = 0.0
var anim_speed : float = 6.0
var speed_multiplier : float = 1.0 # could use for slower mechs?

var paused: bool = false

var hitstop_timer : float = 0.0

func update(delta: float) -> void:
	if paused:
		return
		
	# hitstop timer to freeze anim progression
	if hitstop_timer > 0.0:
		hitstop_timer -= delta
		return
		
	anim_time += delta * anim_speed * speed_multiplier
	
func play(anim: StringName) -> void:
	if current_anim == anim:
		return

	current_anim = anim
	anim_time = 0.0
	
func pause() -> void:
	paused = true
	
func resume() -> void:
	paused = false

func set_paused(value: bool) -> void:
	paused = value
	
func pause_for(seconds: float) -> void:
	paused = true
	await get_tree().create_timer(seconds).timeout
	paused = false

func reset() -> void:
	current_anim = "idle"
	anim_time = 0.0
	
func get_frame(frame_count: int) -> int:
	if frame_count <= 0:
		return 0
	return int(anim_time) % frame_count
	
func is_playing(anim: StringName) -> bool:
	return current_anim == anim
	
func set_speed( mult: float ) -> void:
	speed_multiplier = max(mult, 0.0)
