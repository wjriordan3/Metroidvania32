class_name MechaAnimController extends Node

signal animation_finished(anim_name : StringName)

var current_anim : StringName = &"idle"

# current pos in the animation
var frame_position : float = 0.0
# total lenght of current anim
var anim_frame_count: int = 0

var anim_speed : float = 5.0
var speed_multiplier : float = 1.0 # could use for slower mechs?

var looping : bool = true
var paused: bool = false

var hitstop_timer : float = 0.0
var finished_emitted := false

func update(delta: float) -> void:
	if paused:
		return
		
	# hitstop timer to freeze anim progression
	if hitstop_timer > 0.0:
		hitstop_timer -= delta
		return
		
	if finished_emitted:
		return # anim already finished, non-looping
		
	frame_position += delta * anim_speed * speed_multiplier
	
	if looping or anim_frame_count <= 0:
		return
	
	var last_frame := anim_frame_count - 1
	
	if frame_position >= last_frame:
		frame_position = last_frame
		animation_finished.emit(current_anim)
		finished_emitted = true
		
func play(anim: StringName, frame_count: int, loop := false, restart := false) -> void:
	resume()

	if current_anim == anim and !restart:
		return
	
	current_anim = anim
	anim_frame_count = frame_count
	looping = loop
	
	frame_position = 0.0
	finished_emitted = false
	
func stop() -> void:
	frame_position = 0.0
	finished_emitted = false
	
func reset() -> void:
	current_anim = &"idle"
	frame_position = 0.0
	anim_frame_count = 0
	finished_emitted = false
	
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
	
func set_speed( mult: float ) -> void:
	speed_multiplier = max(mult, 0.0)
	
func is_playing(anim: StringName) -> bool:
	return current_anim == anim
	
func is_anim_finished() -> bool:
	return !looping and finished_emitted	
	
func get_current_frame_count() -> int:
	return anim_frame_count

func get_frame(frame_count: int) -> int:
	if frame_count <= 0:
		return 0
		
	var frame := int(frame_position)
	
	if looping:
		return frame % frame_count
		
	return min(frame, frame_count - 1)

func get_normalized_progress() -> float:
	if anim_frame_count <= 1:
		return 1.0
		
	return clamp(
		frame_position / float(anim_frame_count - 1),
		0.0,
		1.0
	)
	
func apply_hitstop(seconds: float) -> void:
	hitstop_timer = max(hitstop_timer, seconds)
