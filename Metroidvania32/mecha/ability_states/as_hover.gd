class_name AbilityStateHover extends AbilityState

@export var hover_gravity_scale: float = 0.2
@export var max_hover_time: float = 2.5

var timer: float = 0.0

var original_gravity_scale: float
var original_max_fall_speed: float

func enter() -> void:
	timer = max_hover_time
	
	original_gravity_scale = mecha.gravity_multiplier
	original_max_fall_speed = mecha.stats.max_fall_velocity
	
	mecha.gravity_multiplier = hover_gravity_scale
	mecha.stats.max_fall_velocity *= 0.5
	# mecha.play_animation("hover")
	
func exit() -> void:
	mecha.gravity_multiplier = original_gravity_scale
	mecha.stats.max_fall_velocity = original_max_fall_speed
	pass
	
func physics_process( delta: float) -> AbilityState:
	# start timer
	timer -= delta
	
	# continuous damage while active?
	if mecha.velocity.y > 0:
		mecha.velocity.y *= 0.9
		
	mecha.velocity.y -= 10 * delta
	
	# transition back to none_state
	if timer <= 0.0:
		return state_machine.get_state("None")
		
	return null
