class_name PlayerStateFall extends PlayerState

@export var coyote_time : float = 0.125
@export var fall_gravity_multiplier : float = 1.165
@export var jump_buffer_time : float = 0.2

var coyote_timer : float = 0
var buffer_timer : float = 0

var try_grab_ceiling : bool = false

func init() -> void:
	coyote_timer = coyote_time
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	player.sprite.play( "jump" )
	#player.animation_player.play( "jump" )
	#player.animation_player.pause()
	
	player.gravity_multiplier = fall_gravity_multiplier
	if player.previous_state == jump:
		coyote_timer = 0
	else:
		coyote_timer = coyote_time
	pass
	
# What happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1.0
	buffer_timer = 0
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	# Handle inputs
	if _event.is_action_pressed( "jump" ):
		if coyote_timer > 0.0:
			return jump
		else:
			buffer_timer = jump_buffer_time	
		
	if _event.is_action_pressed("up"):
		player.ceiling_grab_buffer = player.CEILING_GRAB_BUFFER_TIME
	
	return next_state
	
func process( _delta: float ) -> PlayerState:
	coyote_timer -= _delta
	buffer_timer -= _delta
	set_jump_frame()
	return next_state 
	
func physics_process( _delta: float ) -> PlayerState:
	if player.try_ceiling_hang():
		return hang
	
	if player.is_on_floor():
		VisualEffects.land_dust( player.one_way_platform_shapecast.global_position )
		if buffer_timer > 0:
			return jump
		return idle
		
	player.velocity.x = player.direction.x * player.stats.base_move_speed
		
	return next_state 
	
func set_jump_frame() -> void:
	# [0.0, max_fall_speed (semi high # for fall velocity)] mapped to [0.5, 0.0 (end of fall in sprite animation)] 
	# TODO: Need to implement set_jump_frame
	#var frame : float = remap( player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0 )
	#player.animation_player.seek( frame, true )
	pass
