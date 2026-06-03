class_name PlayerStateDeath extends PlayerState

# const DEATH_AUDIO = preload()

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	player.sprite.play( "death" )
	# Audio.play_spatial_sound( DEATH_AUDIO, player.global_position )
	# Audio.play_music ( null ) # will transition to no music
	await player.hero_sprite.animation_finished
	PlayerHUD.show_game_over()
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	return null
	
func process( _delta: float) -> PlayerState:
	return null
	
func physics_process( _delta: float) -> PlayerState:
	player.velocity.x = 0
	return null
	
