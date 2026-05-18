extends CanvasLayer

func _ready() -> void:
	visible = false
	get_tree().paused = false 
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true
	
func _on_button_pressed() -> void:
	visible = false
	get_tree().paused = false
