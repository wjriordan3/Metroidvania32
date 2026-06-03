class_name PlayerStateHang extends PlayerState

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	#player.sprite.play( "hang" )
	#player.animation_player.play( "run" )
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("down") or _event.is_action_pressed("jump"):
		player.release_climb_ceiling()
		return fall 
	return next_state
	
#func process( _delta: float) -> PlayerState:
	#if player.direction.x == 0.0:
	#	return idle
	#elif player.direction.y > 0.5:
	#	return crouch
	#return next_state 
	
func physics_process( _delta: float ) -> PlayerState:
	
	if not player.is_on_floor() and not player.is_on_ceiling():
		player.velocity.y += player.gravity * _delta
	elif player.is_on_floor():
		player.ceiling_ray_cast_2d.enabled = true
	else:
		player.velocity.y = 0
		
	if player.is_on_ceiling():
		player.velocity.x += player.direction.x * player.stats.base_move_speed * _delta
	#elif player.is_on_floor():
	
	if player.is_on_floor() == false:
		return fall
	return next_state 
	
