class_name EquippedPart extends RefCounted

var part : MechPart

var current_health : int
var current_ammo : int = 0
var heat : float = 0.0

func _init(new_part: MechPart) -> void:
	part = new_part
	current_health = part.max_health

func is_broken() -> bool:
	return current_health <= 0
	
func damage(amount: int) -> void:
	current_health -= amount
	current_health = max(current_health, 0)
	
func repair(amount: int) -> void:
	current_health += amount
	current_health = min(current_health, part.max_health)

func get_attack() -> int:
	return part.attack_power
	
func get_defense() -> int:
	return part.defense
	
func get_move_bonus() -> float:
	return part.movement_speed_bonus
	
