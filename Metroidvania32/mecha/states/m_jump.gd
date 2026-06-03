class_name MechaStateJump extends MechaState

@export var jump_velocity : float = 450.0

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	mecha.anim_ctrl.play("jump")
	mecha.anim_ctrl.pause()
	#mecha.add_debug_indicator( Color.LIME_GREEN )
	mecha.velocity.y = -jump_velocity
	CameraManager.screen_shake(3.0, 0.25)
	
	# CHeck if this is a buffer jump
	# If it is, handle jump button release condition retroactively
	if mecha.previous_state == fall and not Input.is_action_pressed( "jump" ):
		await get_tree().physics_frame
		mecha.velocity.y *= 0.5
		mecha.change_state( fall )
		pass
		
	
	pass
	
# What happens when we exit this state?
func exit() -> void:
	#mecha.add_debug_indicator( Color.YELLOW )
	pass 
	
func handle_input( event : InputEvent ) -> MechaState:
	# Handle inputs
	if event.is_action_released( "jump" ):
		mecha.velocity.y *= 0.5
		return fall 
	return next_state
	
func process( _delta: float) -> MechaState:
	set_jump_frame()
	mecha.update_direction()
	mecha.velocity.x = mecha.direction.x * mecha.stats.base_move_speed
	return next_state 
	
func physics_process( _delta: float ) -> MechaState:
	if mecha.is_on_floor():
		return idle
	elif mecha.velocity.y >= 0: # positive number in y is downwards
		#mecha.add_debug_indicator( Color.LIME_GREEN )
		return fall
	
	return next_state 
	
func set_jump_frame() -> void:
	# [-jump_velocity, 0.0 (apex of jump)] mapped to [0.0, 0.5 (apex in sprite animation)] 
	# TODO: Need to implement set_jump_frame
	#var frame : float = remap( mecha.velocity.y, -jump_velocity, 0.0, 0.0, 0.5 )
	#mecha.animation_mecha_core.seek( frame, true )
	#mecha.animation_mecha_left_arm.seek( frame, true )
	#mecha.animation_mecha_left_leg.seek( frame, true )
	#mecha.animation_mecha_right_arm.seek( frame, true )
	#mecha.animation_mecha_right_leg.seek( frame, true )
	pass
	
