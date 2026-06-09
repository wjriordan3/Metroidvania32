class_name MechaAnimController extends Node

var current_anim : StringName = "idle"

var anim_time : float = 0.0
var anim_speed : float = 5.0
var speed_multiplier : float = 1.0 # could use for slower mechs?
var looping : bool = true

var paused: bool = false

var hitstop_timer : float = 0.0

signal animation_finished(anim_name : StringName)

var current_frame_count: int = 0
var finished_emitted := false

var anim_frames := {} # Dictionary: StringName -> int (frame count)

func update(delta: float) -> void:
	#print("delta=", delta,"\npaused=", paused, "\nhitstop=", hitstop_timer)
	if paused:
		return
		
	# hitstop timer to freeze anim progression
	if hitstop_timer > 0.0:
		hitstop_timer -= delta
		return
		
	# Once a non-looping animation is finished,
	# keep it on the final frame.
	if !looping and finished_emitted:
		return
	
	
	anim_time += delta * anim_speed * speed_multiplier
	#print("Current Anim_Time: ", anim_time)
	
	if looping:
		return
		
	var frame_count := get_current_frame_count()

	if frame_count <= 0:
		return

	var last_frame := frame_count - 1

	if anim_time >= last_frame:
		anim_time = last_frame
		finished_emitted = true
		animation_finished.emit(current_anim)
			
		
func play(anim: StringName, loop := false, restart := false) -> void:
	resume()

	if current_anim == anim and !restart:
		return

	current_anim = anim
	looping = loop
	anim_time = 0.0
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

func reset() -> void:
	current_anim = "idle"
	anim_time = 0.0
	
func get_frame(frame_count: int) -> int:
	if frame_count <= 0:
		return 0
		
	var frame := int(anim_time)
	
	if looping:
		return frame % frame_count
		
	return min(frame, frame_count - 1)
	
func is_playing(anim: StringName) -> bool:
	return current_anim == anim
	
func is_anim_finished_by_frame_count(frame_count : int ) -> bool:
	return !looping and int(anim_time) >= frame_count
	
func is_anim_finished() -> bool:
	if looping:
		return false
	var frame_count = anim_frames.get(current_anim, 1)
	return int(anim_time) >= frame_count
	
func set_speed( mult: float ) -> void:
	speed_multiplier = max(mult, 0.0)

func set_animation_frames(anim_name: StringName, frame_count: int) -> void:
	anim_frames[anim_name] = frame_count
	
func set_frame_count(sprite: AnimatedSprite2D) -> void:
	if sprite == null or sprite.sprite_frames == null:
		current_frame_count = 0
		return
	
	# Make sure the animation exists
	if !sprite.sprite_frames.has_animation(current_anim):
		current_frame_count = 0
		return
	
	current_frame_count = sprite.sprite_frames.get_frame_count(current_anim)
	
func get_frame_count(sprite: AnimatedSprite2D, anim: StringName) -> int:
	if sprite.sprite_frames == null:
		return 0
	return sprite.sprite_frames.get_frame_count(anim)
	

func get_animation_frame_count(anim_name: StringName) -> int:
	return anim_frames.get(anim_name, 0)


func get_current_frame_count() -> int:
	return anim_frames.get(current_anim, 0)
