class_name PlayerStateIdle extends PlayerState

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
	if _event.is_action_pressed("jump"):
		return jump
	return next_state
	
func process( _delta: float) -> PlayerState:
	if player.direction.x != 0.0:
		return run
	return next_state 
	
func physics_process( _delta: float) -> PlayerState:
	player.velocity.x = 0.0
	return next_state 
	
