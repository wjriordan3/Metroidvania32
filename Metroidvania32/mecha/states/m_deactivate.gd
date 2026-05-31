class_name MechaStateDeactivate extends MechaState

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	mecha.mech_animate_play(
		"standard_idle",
		"standard_idle",
		"standard_idle",
		"standard_idle",
		"standard_idle"
	)
	
	# TODO: replace mech_animate_play with play_mech_animation
	#mecha.play_mech_animation(&"idle")
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> MechaState:
	# Handle inputs
	if _event.is_action_pressed("jump"):
		return jump
	return next_state
	
func process( _delta: float) -> MechaState:
	if mecha.direction.x != 0.0:
		return run
	elif mecha.direction.y > 0.5:
		return crouch
	return next_state 
	
func physics_process( _delta: float) -> MechaState:
	mecha.velocity.x = 0.0
	if mecha.is_on_floor() == false:
		return fall
	return next_state 
	
