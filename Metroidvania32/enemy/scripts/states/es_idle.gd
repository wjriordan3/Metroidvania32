class_name ESIdle
extends EnemyState


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard


func enter() -> void :
	var anim : String = animation_name if animation_name else "idle"
	enemy.play_animation( anim )
	pass
	
func re_enter() -> void :
	pass
	
func exit() -> void :
	pass
