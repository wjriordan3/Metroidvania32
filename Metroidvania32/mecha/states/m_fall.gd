class_name MechaStateFall extends MechaState

@export var coyote_time : float = 0.125
@export var fall_gravity_multiplier : float = 1.165
@export var jump_buffer_time : float = 0.2

var coyote_timer : float = 0
var buffer_timer : float = 0

func init() -> void:
	coyote_timer = coyote_time
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	mecha.mech_animate_play(
		"standard_jump",
		"standard_jump",
		"standard_jump",
		"standard_jump",
		"standard_jump"
	)
	mecha.mech_animate_pause()
	
	mecha.gravity_multiplier = fall_gravity_multiplier
	if mecha.previous_state == jump:
		coyote_timer = 0
	else:
		coyote_timer = coyote_time
	pass
	
# What happens when we exit this state?
func exit() -> void:
	mecha.gravity_multiplier = 1.0
	buffer_timer = 0
	pass 
	
func handle_input( _event : InputEvent ) -> MechaState:
	# Handle inputs
	if _event.is_action_pressed( "jump" ):
		if coyote_timer > 0.0:
			return jump
		else:
			buffer_timer = jump_buffer_time	
		
	return next_state
	
func process( _delta: float ) -> MechaState:
	coyote_timer -= _delta
	buffer_timer -= _delta
	set_jump_frame()
	return next_state 
	
func physics_process( _delta: float ) -> MechaState:
	if mecha.is_on_floor():
		#mecha.add_debug_indicator( ) 
		if buffer_timer > 0:
			return jump
		CameraManager.screen_shake(3.0, 0.25)
		return idle
	return next_state 
	
func set_jump_frame() -> void:
	# [0.0, max_fall_speed (semi high # for fall velocity)] mapped to [0.5, 0.0 (end of fall in sprite animation)] 
	# TODO: Need to implement set_jump_frame
	#var frame : float = remap( mecha.velocity.y, 0.0, mecha.max_fall_velocity, 0.5, 1.0 )
	#mecha.animation_mecha_core.seek( frame, true )
	#mecha.animation_mecha_left_arm.seek( frame, true )
	#mecha.animation_mecha_left_leg.seek( frame, true )
	#mecha.animation_mecha_right_arm.seek( frame, true )
	#mecha.animation_mecha_right_leg.seek( frame, true )
	pass
