class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450.0

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	player.add_debug_indicator( Color.LIME_GREEN )
	# Play animation here
	player.velocity.y = -jump_velocity
	pass
	
# What happens when we exit this state?
func exit() -> void:
	player.add_debug_indicator( Color.YELLOW )
	pass 
	
func handle_input( event : InputEvent ) -> PlayerState:
	# Handle inputs
	if event.is_action_released( "jump" ):
		player.velocity.y *= 0.5
		return fall 
	return next_state
	
func process( _delta: float) -> PlayerState:
	player.update_direction()
	player.velocity.x = player.direction.x * player.move_speed
	return next_state 
	
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0: # positive number in y is downwards
		player.add_debug_indicator( Color.LIME_GREEN )
		return fall
	
	return next_state 
	
