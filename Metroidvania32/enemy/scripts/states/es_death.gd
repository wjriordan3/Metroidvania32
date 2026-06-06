class_name ESDeath extends EnemyState


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard

@export var walk_speed : float = 50

func enter() -> void :
	enemy.play_animation( "test" )
	pass
	
func re_enter() -> void :
	pass
	
func exit() -> void :
	pass
