extends HBoxContainer

var max_health = 100.0

func initialize(max):
	max_health = max
	$TextureProgressBar.max_value = max
	$Counter/Label.text = "%s" % [max]
	
func update_health(health):
	$TextureProgressBar.value = health
	$Counter/Label.text = "%s" % [health]

func _on_interface_health_changed(health):
	update_health(health)
