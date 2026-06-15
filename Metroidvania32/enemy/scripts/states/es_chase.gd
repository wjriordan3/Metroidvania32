class_name ESChase
extends EnemyState


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard
@export var walk_speed : float = 50
@export var jump_speed : float = 450



func enter() -> void :
	var anim : String = animation_name if animation_name else "walk"
	enemy.play_animation( anim )
	pass
	
func re_enter() -> void :
	pass
	
func exit() -> void :
	pass
	
func physics_update( _delta : float ):
	if enemy.global_position.x > blackboard.target.global_position.x:
		blackboard.dir = -1
		enemy.change_dir( blackboard.dir )
	elif enemy.global_position.x < blackboard.target.global_position.x:
		blackboard.dir = 1
		enemy.change_dir( blackboard.dir )
	enemy.velocity.x = walk_speed * blackboard.dir
	
	if enemy.is_on_wall():
		enemy.velocity.y = -jump_speed
	pass
