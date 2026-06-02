class_name LimbHealth extends Node

# Array of limb health nodes
@export var limb_healths = []

signal limb_health_changed(limb, health)

func _ready() -> void:
	limb_healths = get_children()

func _on_left_arm_health_health_changed(health: int) -> void:
	limb_health_changed.emit("LEFT_ARM", health)


func _on_right_arm_health_health_changed(health: int) -> void:
	limb_health_changed.emit("RIGHT_ARM", health)


func _on_left_leg_health_health_changed(health: int) -> void:
	limb_health_changed.emit("LEFT_LEG", health)


func _on_right_leg_health_health_changed(health: int) -> void:
	limb_health_changed.emit("RIGHT_LEG", health)
