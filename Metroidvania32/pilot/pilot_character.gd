class_name PilotCharacter extends CharacterBody2D

var current_mech : MechaUnit = null

@export var can_pilot_mechs := true

func get_move_input() -> Vector2:
	return Vector2.ZERO

func get_left_arm_input() -> bool:
	return false
	
func get_right_arm_input() -> bool:
	return false
	
func get_left_leg_input() -> bool:
	return false
	
func get_right_leg_input() -> bool:
	return false
	
func on_enter_mech(mech: MechaUnit) -> void:
	current_mech = mech
	
func on_exit_mech() -> void:
	current_mech = null

func is_in_mech() -> bool:
	return current_mech != null	
