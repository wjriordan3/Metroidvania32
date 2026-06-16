class_name ESShoot
extends EnemyState


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard

@export var attack_audio : AudioStream
var duration : float = .5
var timer : float = 0

func enter() -> void :
	var anim : String = animation_name if animation_name else "attack"
	if enemy.animation.current_animation == anim :
		enemy.animation.seek( 0 )
	else:
		enemy.play_animation( anim )
		enemy.enemy_gun.shoot( blackboard.dir )

		
	duration = enemy.animation.current_animation_length
	timer = 0
	
	
func re_enter() -> void :
	pass
	
func exit() -> void :
	pass

func physics_update( delta : float ) -> void :
	if enemy.decision_engine is DecisionEngineGrunt :
		timer += delta
		if timer >= duration :
			blackboard.can_decide = true
		pass
	pass
