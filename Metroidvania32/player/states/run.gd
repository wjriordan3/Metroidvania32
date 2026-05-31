class_name PlayerStateRun extends PlayerState

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	player.hero_sprite.play( "run" )
	#player.animation_player.play( "run" )
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump
	if player.direction.x != 0 and _event.is_action_pressed("fire"):
		return attack
	return next_state
	
func process( _delta: float) -> PlayerState:
	if player.direction.x == 0.0:
		return idle
	elif player.direction.y > 0.5:
		return crouch
	return next_state 
	
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.stats.base_move_speed 
	if player.is_on_floor() == false:
		return fall
	return next_state 
	
