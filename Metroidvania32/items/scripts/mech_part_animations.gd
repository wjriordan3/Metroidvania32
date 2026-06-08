class_name MechPartAnimations
extends Resource

@export var idle : StringName
@export var idle_02 : StringName

@export var run : StringName
@export var jump : StringName
@export var fall : StringName
@export var hang : StringName

@export_category("Actions")

@export var leftArm_action : StringName
@export var rightArm_action : StringName
@export var leftLeg_action : StringName
@export var rightLeg_action : StringName

@export_category("Damage")

@export var hurt : StringName
@export var death : StringName
@export var death_02 : StringName

func get_anim(key: StringName) -> StringName:
	match key:
		"idle": return idle
		"idle_02" : return idle_02
		"run": return run
		"jump": return jump
		"fall": return fall
		"hang": return hang
		"leftArm": return leftArm_action
		"rightArm": return rightArm_action
		"leftLeg": return leftLeg_action
		"rightLeg": return rightLeg_action
		"hurt": return hurt
		"death": return death
		"death_02" : return death_02
		_: return ""
