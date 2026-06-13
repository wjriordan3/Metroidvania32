extends HBoxContainer

var max_health = 100.0
@onready var hp_bar: TextureProgressBar = %HPBar

func initialize(max):
	max_health = max
	hp_bar.max_value = max
	
func update_health(health):
	hp_bar.value = health

func _on_interface_health_changed(health):
	update_health(health)
