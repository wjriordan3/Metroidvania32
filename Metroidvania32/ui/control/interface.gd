class_name Interface extends Control

signal health_changed(health)

@export var player_health = Node
@export var player_inventory = Control
@export var limb_health = Node

func _ready():
	$HealthBar.initialize(player_health.max_health)
	$ScrapCounter.update_counter(player_inventory.scrap)
	$LimbDisplay.initialize(limb_health.limb_healths)

func _on_health_health_changed(health):
	health_changed.emit(health)

func _on_inventory_add_scrap(scrap: int) -> void:
	$ScrapCounter.update_counter(scrap)
	
func _on_inventory_new_item(item: Object) -> void:
	$Notification.item_notif(item.itemIcon, item.itemName)

func _on_limb_health_limb_health_changed(limb: Variant, health: int) -> void:
	$LimbDisplay.update_health(limb, health)
