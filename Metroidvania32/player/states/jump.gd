class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450.0

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	VisualEffects.jump_dust( player.one_way_platform_shapecast.global_position )
	# Play animation here
	player.sprite.play( "jump" )
	#player.animation_player.play( "jump" )
	#player.animation_player.pause() 
	#player.add_debug_indicator( Color.LIME_GREEN )
	player.velocity.y = -jump_velocity
	
	# CHeck if this is a buffer jump
	# If it is, handle jump button release condition retroactively
	if player.previous_state == fall and not Input.is_action_pressed( "jump" ):
		await get_tree().physics_frame
		player.velocity.y *= 0.5
		player.change_state( fall )
		pass
		
	
	pass
	
# What happens when we exit this state?
func exit() -> void:
	#player.add_debug_indicator( Color.YELLOW )
	pass 
	
func handle_input( event : InputEvent ) -> PlayerState:
	# Handle inputs
	if event.is_action_released( "jump" ):
		player.velocity.y *= 0.5
		return fall 
		
	if event.is_action_pressed("up"):
		player.ceiling_grab_buffer = player.CEILING_GRAB_BUFFER_TIME
		
	return next_state
	
func process( _delta: float) -> PlayerState:
	set_jump_frame()
	player.update_direction()
	player.velocity.x = player.direction.x * player.stats.base_move_speed
	return next_state 
	
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	# Check for ceiling hang
	if player.try_ceiling_hang():
		return hang
		
	if player.velocity.y >= 0: # positive number in y is downwards
		#player.add_debug_indicator( Color.LIME_GREEN )
		return fall
		
	player.velocity.x = player.direction.x * player.stats.base_move_speed
	
	return next_state 
	
func set_jump_frame() -> void:
	# [-jump_velocity, 0.0 (apex of jump)] mapped to [0.0, 0.5 (apex in sprite animation)] 
	# TODO: Need to implement set_jump_frame
	#var frame : float = remap( player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5 )
	#player.animation_player.seek( frame, true )
	pass
	
