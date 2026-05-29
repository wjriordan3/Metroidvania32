extends Panel

# Helper function
func _set_notif(icon, text):
	$Label.text = text
	$Sprite2D.texture = icon

# When picking up an item
func item_notif(icon, item_name):
	_set_notif(icon, item_name)
	visible = true

# Close notification when timer is done
func _on_timer_timeout() -> void:
	visible = false
