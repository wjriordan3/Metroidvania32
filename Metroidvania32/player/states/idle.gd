class_name PlayerStateIdle extends PlayerState

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	player.mech_animate_play(
		"PlayerAnims/standard_idle_core",
		"PlayerAnims/standard_idle_leftarm",
		"PlayerAnims/standard_idle_leftleg",
		"PlayerAnims/standard_idle_rightarm",
		"PlayerAnims/standard_idle_rightleg"
	)
	
	# TODO: replace mech_animate_play with play_mech_animation
	#player.play_mech_animation(&"idle")
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	# Handle inputs
	if _event.is_action_pressed("jump"):
		return jump
	return next_state
	
func process( _delta: float) -> PlayerState:
	if player.direction.x != 0.0:
		return run
	elif player.direction.y > 0.5:
		return crouch
	return next_state 
	
func physics_process( _delta: float) -> PlayerState:
	player.velocity.x = 0.0
	if player.is_on_floor() == false:
		return fall
	return next_state 
	
