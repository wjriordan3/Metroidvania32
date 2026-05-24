extends HBoxContainer

var max_health = 100.0

func initialize(max):
	max_health = max
	$TextureProgressBar.max_value = max

func _on_interface_health_changed(health):
	$TextureProgressBar.value = health
	$Counter/Label.text = "%s" % [health]
