class_name MechaStateCrouch extends MechaState

@export var deceleration_rate : float = 10 # pixels per second
@export var crouch_move_multiplier : float = 0.5

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	mecha.collision_stand.disabled = true
	mecha.collision_crouch.disabled = false
	mecha.crouch_multiplier = crouch_move_multiplier
	
	# TODO: Remove sprite scaling upon use of crouch sprite animation
	#mecha.core.scale.y = 0.625
	#mecha.core.position.y = 30
	pass
	
# What happens when we exit this state?
func exit() -> void:
	mecha.collision_stand.disabled = false
	mecha.collision_crouch.disabled = true
	mecha.crouch_multiplier = 1.0
	
	# TODO: Remove sprite scaling upon use of crouch sprite animation
	#mecha.core.scale.y = 1.0
	#mecha.core.position.y = 0.0
	pass 
	
func handle_input( _event : InputEvent ) -> MechaState:
	# Handle inputs
	if _event.is_action_pressed("jump"):
		mecha.one_way_platform_shapecast.force_shapecast_update()
		if mecha.one_way_platform_shapecast.is_colliding():
			mecha.position.y += 4 # move mecha enough to fall through platform
			return fall
		return jump
	return next_state
	
func process( _delta: float) -> MechaState:
	if mecha.direction.y <= 0.5:
		return idle
	return next_state 
	
func physics_process( _delta: float) -> MechaState:
	#mecha.velocity.x = mecha.direction.x * mecha.move_speed * mecha.crouch_multiplier
	
	mecha.velocity.x -= mecha.velocity.x * deceleration_rate * _delta 
	if mecha.is_on_floor() == false:
		return fall
	return next_state 
	
