class_name Interface extends Control

signal health_changed(health)
signal scrap_changed(scrap)

@export var player_health = Node
@export var player_inventory = Control

func _ready():
	$HealthBar.initialize(player_health.max_health)
	$ScrapCounter.initialize(player_inventory.scrap)

func _on_health_health_changed(health):
	emit_signal("health_changed", health)


func _on_inventory_add_scrap(scrap: int) -> void:
	emit_signal("scrap_changed", scrap)
