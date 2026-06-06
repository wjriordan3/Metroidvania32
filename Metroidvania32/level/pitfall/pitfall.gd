extends Area2D

var curr_screen = Camera2D

func _on_body_entered(body: Node2D) -> void:
	# Get the current camera
	curr_screen = CameraManager.get_active_camera()
	
	print( "Body entered: ", body.name )
	# Respawn player at beginning of current screen
	if body is Player:
		PlayerManager.set_player_position(
			CameraManager.get_left_spawn_position(curr_screen)
		)
	elif body is MechaUnit and body.is_in_group("player"):
		PlayerManager.set_mecha_position(
			CameraManager.get_left_spawn_position(curr_screen)
		)
