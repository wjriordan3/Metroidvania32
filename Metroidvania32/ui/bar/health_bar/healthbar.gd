extends HBoxContainer

var max_health = 100.0
@onready var hp_bar: TextureProgressBar = %HPBar
@onready var label: Label = $Counter/Label

func initialize(max):
	max_health = max
	hp_bar.max_value = max
	label.text = "%s" % [max]
	
func update_health(health):
	hp_bar.value = health
	label.text = "%s" % [health]

func _on_interface_health_changed(health):
	update_health(health)
