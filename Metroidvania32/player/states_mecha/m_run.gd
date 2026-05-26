class_name MechaStateRun extends MechaState

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	player.mech_animate_play(
		"standard_run",
		"standard_run",
		"standard_run",
		"standard_run",
		"standard_run"
	)
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> MechaState:
	if _event.is_action_pressed("jump"):
		return jump
	return next_state
	
func process( _delta: float) -> MechaState:
	if player.direction.x == 0.0:
		return idle
	elif player.direction.y > 0.5:
		return crouch
	return next_state 
	
func physics_process( _delta: float ) -> MechaState:
	player.velocity.x = player.direction.x * player.move_speed 
	if player.is_on_floor() == false:
		return fall
	return next_state 
	
