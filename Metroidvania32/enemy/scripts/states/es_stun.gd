class_name ESStun extends EnemyState


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard
var knockback_strength : float = 100
var vel_x : float = 0
@export var duration : float
var timer : float = 0
var flipped_left = false
var flipped_right = false

func start() -> void :
	var anim : String = animation_name if animation_name else "stun"
	if enemy.animation.current_animation == anim :
		enemy.animation.seek( 0 )
	else:
		enemy.play_animation( anim )
	
	if not duration:
		duration = enemy.animation.current_animation_length
		
	timer = 0
	_calc_velocity( blackboard.damage_source )
	blackboard.damage_source = null
	blackboard.can_decide = false
	pass

func enter() -> void :
	start()
	pass
	
func re_enter() -> void :
	pass
	
func exit() -> void :
	if flipped_right :
		enemy.sprite.flip_h = true
		flipped_right = false
	if flipped_left :
		enemy.sprite.flip_h = false
		flipped_left = false
	blackboard.can_decide = true
	pass
	
func physics_update( delta : float ) -> void :
	timer += delta
	enemy.velocity.x = vel_x * ( 1 - timer / duration )
	if timer >= duration :
		blackboard.can_decide = true
	pass

func _calc_velocity( a : AttackArea ) -> void :
	print( "calc knockback" )
	vel_x = 1
	if a.global_position.x > enemy.global_position.x:
		vel_x = -1
		if blackboard.dir < 0:
			enemy.sprite.flip_h = false
			flipped_right = true
	elif blackboard.dir > 0:
		enemy.sprite.flip_h = true
		flipped_left = true
	vel_x *= knockback_strength
	pass
	
