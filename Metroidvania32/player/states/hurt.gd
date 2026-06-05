class_name PlayerStateHurt extends PlayerState

@export var move_speed : float = 100
@export var invulnerable_duration : float = 0.5
@export var stun_time : float = 0.8
var time : float = 0.0
var dir : float = 1.0
@onready var damage_area: DamageArea = %DamageArea


func init() -> void:
	damage_area.damage_taken.connect( _on_damage_taken )
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	player.sprite.play( "hurt" )
	# set length of hitstun
	time = stun_time
	# make invulnerable
	damage_area.make_invulnerable( invulnerable_duration )
	# play audio
	#Audio.play_spatial_sound("")
	CameraManager.screen_shake(1.0, 0.25)
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	return null
	
func process( _delta: float) -> PlayerState:
	time -= _delta
	if time <= 0:
		if player.stats.health <= 0:
			return death
		return idle
	return null
	
func physics_process( _delta: float) -> PlayerState:
	player.velocity.x = move_speed * dir
	return null
	
func _on_damage_taken( attack_area : AttackArea ) -> void:
	if player.current_state == death:
		return
	player.change_state ( self ) 
	if attack_area.global_position.x < player.global_position.x:
		dir = 1.0
	else:
		dir = -1.0
	pass
