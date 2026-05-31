class_name PlayerStateAttack extends PlayerState

#const audio_attack = preload()

@export var combo_time_window : float = 0.2
@export var speed : float = 150
var timer : float = 0
var combo : int = 0

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	#player.hero_sprite.play( "attack" )
	
	#player.animation_player.play( "idle" )
	
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	# Handle inputs
	return null
	
func process( _delta: float) -> PlayerState:
	
	return null
	
func physics_process( _delta: float) -> PlayerState:
	if player.shoot_timer.is_stopped():
		if player.is_shooting:
			player.shoot_timer.start()
		#player.hero_sprite.play( "attack" )
	return idle 
	
