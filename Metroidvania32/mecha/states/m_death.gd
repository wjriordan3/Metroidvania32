class_name MechaStateDeath extends MechaState

# const DEATH_AUDIO = preload()

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	mecha.anim_ctrl.play("death")
	# Audio.play_spatial_sound( DEATH_AUDIO, mecha.global_position )
	# Audio.play_music ( null ) # will transition to no music
	await mecha.anim_ctrl.animation_finished
	PlayerHUD.show_game_over()
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> MechaState:
	return null
	
func process( _delta: float) -> MechaState:
	return null 
	
func physics_process( _delta: float) -> MechaState:
	mecha.velocity.x = 0.0
	return null
