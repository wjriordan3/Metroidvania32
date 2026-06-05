class_name MechaStateDeactivate extends MechaState

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	mecha.anim_ctrl.play("deactivate", false)
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> MechaState:
	return next_state
	
func process( _delta: float) -> MechaState:
	if !mecha.anim_ctrl.is_anim_finished():
		return idle
	return next_state 
	
func physics_process( _delta: float) -> MechaState:
	return next_state 
	
