extends CanvasLayer

@onready var interface: Interface = $Interface
@onready var health_bar = $Interface/HealthBar
@onready var scrap_counter: Counter = $Interface/ScrapCounter
@onready var limb_display: GridContainer = $Interface/LimbDisplay
@onready var hp_bar: TextureProgressBar = $Interface/HealthBar/HPBar

signal health_changed(health)

func _ready() -> void:
	print("Player HUD added to game")
	# connect to message bus
	Messages.player_health_changed.connect ( update_health_bar )
	
	#health_bar.initialize(player_health.max_health)
	#scrap_counter.update_counter(player_inventory.scrap)
	#limb_display.initialize(limb_health.limb_healths)
	
	pass
	
func show_player_hud() -> void:
	interface.visible = true
	
func hide_player_hud() -> void:
	interface.visible = false
	
func _on_health_health_changed(health):
	health_changed.emit(health)

func update_health_bar( hp: float, max_hp : float ) -> void:
	var value : float = ( hp / max_hp ) * 100
	hp_bar.value = value
	# hp_margin_container.size.x = max_hp + 22
	pass
	
func _on_inventory_add_scrap(scrap: int) -> void:
	$ScrapCounter.update_counter(scrap)
	
func _on_inventory_new_item(item: Object) -> void:
	$Notification.item_notif(item.itemIcon, item.itemName)

func _on_limb_health_limb_health_changed(limb: Variant, health: int) -> void:
	$LimbDisplay.update_health(limb, health)


	
