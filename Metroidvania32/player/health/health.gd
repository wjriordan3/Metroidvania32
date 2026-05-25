extends Node

signal health_changed(health)
signal health_depleted

var health = 0
@export var max_health = 100.0

func _ready():
	health = max_health
	health_changed.emit(health)

func take_damage(amount):
	health -= amount
	health = max(0, health)
	health_changed.emit(health)

func heal(amount):
	health += amount
	health = max(health, max_health)
	health_changed.emit(health)
