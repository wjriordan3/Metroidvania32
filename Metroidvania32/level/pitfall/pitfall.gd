extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print( "Body entered: ", body.name )
	# Respawn player at beginning of current screen
	if body.is_in_group("player") :
		PlayerManager.set_player_position(CameraManager.get_left_spawn_position(CameraManager.get_active_camera()))
