class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450.0

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	player.add_debug_indicator( Color.LIME_GREEN )
	# Play animation here
	player.mech_animate_play(
		"PlayerAnims/standard_jump_core",
		"PlayerAnims/standard_jump_leftarm",
		"PlayerAnims/standard_jump_leftleg",
		"PlayerAnims/standard_jump_rightarm",
		"PlayerAnims/standard_jump_rightleg"
	)
	player.mech_animate_pause()
	
	
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
	set_jump_frame()
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
	
func set_jump_frame() -> void:
	# [-jump_velocity, 0.0 (apex of jump)] mapped to [0.0, 0.5 (apex in sprite animation)] 
	var frame : float = remap( player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5 )
	player.animation_player_core.seek( frame, true )
	player.animation_player_left_arm.seek( frame, true )
	player.animation_player_left_leg.seek( frame, true )
	player.animation_player_right_arm.seek( frame, true )
	player.animation_player_right_leg.seek( frame, true )
	pass
	
