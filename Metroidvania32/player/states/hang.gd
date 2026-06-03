class_name PlayerStateHang extends PlayerState

var hang_offset_y := 8.0

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	print("entering the hang state")
	player.gravity_multiplier = 0
	player.velocity.y = 0
	
	#var ray = player.ceiling_ray_cast_2d
	
	#if ray.is_colliding():
	#	var dist = ray.get_collision_point().y - player.global_position.y
	#	player.global_position.y += dist + hang_offset_y
	
	# Play animation here
	#player.sprite.play( "hang" )
	pass
	
# What happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed("down") or _event.is_action_pressed("jump"):
		return fall 
	return next_state
	
#func process( _delta: float) -> PlayerState:
	#if player.direction.x == 0.0:
	#	return idle
	#elif player.direction.y > 0.5:
	#	return crouch
	#return next_state 
	
func physics_process( _delta: float ) -> PlayerState:
	# no more ceiling -> fall
	if not player.ceiling_ray_cast_2d.is_colliding():
		return fall
	# Stay attached
	player.velocity.y = 0
	# Move along ceiling
	player.velocity.x = player.direction.x * player.stats.base_move_speed
	return next_state
	
