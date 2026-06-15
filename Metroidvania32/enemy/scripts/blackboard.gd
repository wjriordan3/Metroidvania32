class_name Blackboard extends Resource

var health : float = 3
var target : CharacterBody2D = null
var distance_to_target : float = -1
var can_decide : bool = true
var edge_detected : bool = false
var damage_source : AttackArea = null
var dir : float = 1.0


func update_distance_to_target( pos : Vector2 ) -> void :
	if target:
		distance_to_target = pos.distance_to( target.global_position )
	else:
		distance_to_target = -1
	pass
	
func is_level_with_target( pos : Vector2 ) -> bool :
	
	var target_y : float
	var this_y : float = pos.y
	if target :
		target_y = target.global_position.y
		if target_y - this_y > -20 and target_y - this_y < 20 :
			return true
	return false
