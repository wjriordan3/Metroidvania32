class_name MechPartAnimations
extends Resource

@export var idle : StringName
@export var run : StringName
@export var jump : StringName
@export var fall : StringName
@export var hang : StringName

@export_category("Actions")

@export var primary_action : StringName
@export var secondary_action : StringName

@export_category("Damage")

@export var damaged : StringName
@export var destroyed : StringName

func get_anim(key: StringName) -> StringName:
	match key:
		"idle": return idle
		"run": return run
		"jump": return jump
		"fall": return fall
		"hang": return hang
		"action": return primary_action
		"action_2": return secondary_action
		"damaged": return damaged
		"destroyed": return destroyed
		_: return ""
