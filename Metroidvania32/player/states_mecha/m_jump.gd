class_name MechaStateJump extends MechaState

@export var jump_velocity : float = 450.0

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	player.mech_animate_play(
		"jump",
		"jump",
		"jump",
		"jump",
		"jump"
	)
	player.mech_animate_pause()
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
	
func handle_input( event : InputEvent ) -> MechaState:
	# Handle inputs
	if event.is_action_released( "jump" ):
		player.velocity.y *= 0.5
		return fall 
	return next_state
	
func process( _delta: float) -> MechaState:
	set_jump_frame()
	player.update_direction()
	player.velocity.x = player.direction.x * player.move_speed
	return next_state 
	
func physics_process( _delta: float ) -> MechaState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0: # positive number in y is downwards
		#player.add_debug_indicator( Color.LIME_GREEN )
		return fall
	
	return next_state 
	
func set_jump_frame() -> void:
	# [-jump_velocity, 0.0 (apex of jump)] mapped to [0.0, 0.5 (apex in sprite animation)] 
	var frame : float = remap( player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5 )
	#player.animation_player_core.seek( frame, true )
	#player.animation_player_left_arm.seek( frame, true )
	#player.animation_player_left_leg.seek( frame, true )
	#player.animation_player_right_arm.seek( frame, true )
	#player.animation_player_right_leg.seek( frame, true )
	pass
	
