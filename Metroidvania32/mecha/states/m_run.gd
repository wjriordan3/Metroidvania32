class_name MechaStateRun extends MechaState

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	mecha.anim_ctrl.play("run")
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> MechaState:
	if _event.is_action_pressed("jump"):
		return jump
	return next_state
	
func process( _delta: float) -> MechaState:
	if mecha.direction.x == 0.0:
		return idle
	elif mecha.direction.y > 0.5:
		return crouch
	return next_state 
	
func physics_process( _delta: float ) -> MechaState:
	mecha.velocity.x = mecha.direction.x * mecha.stats.base_move_speed 
	if mecha.is_on_floor() == false:
		return fall
	return next_state 
	
