class_name ESWalk extends EnemyState


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard
@export var walk_speed : float = 50



func enter() -> void :
	var anim : String = animation_name if animation_name else "walk"
	enemy.play_animation( anim )
	pass
	
func re_enter() -> void :
	pass
	
func exit() -> void :
	pass
	
func physics_update( _delta : float ):
	if enemy.is_on_wall():
		enemy.change_dir( -blackboard.dir )
	enemy.velocity.x = walk_speed * blackboard.dir
	pass
