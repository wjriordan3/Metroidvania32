class_name PlayerStateCrouch extends PlayerState

@export var deceleration_rate : float = 10 # pixels per second
@export var crouch_move_multiplier : float = 0.5

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.crouch_multiplier = crouch_move_multiplier
	
	# TODO: Remove sprite scaling upon use of crouch sprite animation
	player.core.scale.y = 0.625
	player.core.position.y = 30
	pass
	
# What happens when we exit this state?
func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	player.crouch_multiplier = 1.0
	
	# TODO: Remove sprite scaling upon use of crouch sprite animation
	player.core.scale.y = 1.0
	player.core.position.y = 0.0
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	# Handle inputs
	if _event.is_action_pressed("jump"):
		player.one_way_platform_shapecast.force_shapecast_update()
		if player.one_way_platform_shapecast.is_colliding():
			player.position.y += 4 # move player enough to fall through platform
			return fall
		return jump
	return next_state
	
func process( _delta: float) -> PlayerState:
	if player.direction.y <= 0.5:
		return idle
	return next_state 
	
func physics_process( _delta: float) -> PlayerState:
	#player.velocity.x = player.direction.x * player.move_speed * player.crouch_multiplier
	
	player.velocity.x -= player.velocity.x * deceleration_rate * _delta 
	if player.is_on_floor() == false:
		return fall
	return next_state 
	
