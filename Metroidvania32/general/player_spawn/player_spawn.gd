@icon( "res://general/icons/player_spawn.svg" )
class_name PlayerSpawn extends Node2D

func _ready() -> void:
	visible = false
	
	await get_tree().process_frame
	# Check to see if we already have a player
	if get_tree().get_first_node_in_group("player"):
		print("Player found! Moving to spawn position at: ", global_position)
		PlayerManager.set_player_position( global_position )
	
	if PlayerManager.player_spawned == false:
		print("No player found. Instantiating new player instance.")
		PlayerManager.add_player_instance()
		print("Now moving player")
		PlayerManager.set_player_position( global_position )
		PlayerManager.player_spawned = true
