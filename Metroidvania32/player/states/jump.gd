class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450.0

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	player.velocity.y = -jump_velocity
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	# Handle inputs
	return next_state
	
func process( _delta: float) -> PlayerState:
	player.update_direction()
	player.velocity.x = player.direction.x * player.move_speed
	return next_state 
	
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0: # positive number in y is downwards
		return fall
	
	return next_state 
	
