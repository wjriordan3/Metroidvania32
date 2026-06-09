class_name MechaStateHurt extends MechaState

@export var move_speed : float = 80
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
	mecha.play_animation("hurt")
	#mecha.anim_ctrl.play( "hurt" )
	# set length of hitstun
	time = stun_time
	# make invulnerable
	damage_area.make_invulnerable( invulnerable_duration )
	# play audio
	#Audio.play_spatial_sound("")
	CameraManager.screen_shake(0.8, 0.20)
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> MechaState:
	return null
	
func process( _delta: float) -> MechaState:
	time -= _delta
	if time <= 0:
		if mecha.stats.health <= 0:
			return death
		return idle
	return null
	
func physics_process( _delta: float) -> MechaState:
	mecha.velocity.x = move_speed * dir
	return null
	
func _on_damage_taken( attack_area : AttackArea ) -> void:
	if mecha.current_state == death:
		return
	mecha.change_state ( self ) 
	if attack_area.global_position.x < mecha.global_position.x:
		dir = 1.0
	else:
		dir = -1.0
	pass
