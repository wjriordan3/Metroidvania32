class_name PlayerStateFall extends PlayerState

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	# Handle inputs
	return next_state
	
func process( _delta: float) -> PlayerState:
	return next_state 
	
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	return next_state 
	
