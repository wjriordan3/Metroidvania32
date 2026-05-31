@icon( "res://general/icons/player_spawn.svg" )
class_name PlayerSpawn extends Node2D

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	# Check to see if we already have a player
	if get_tree().get_first_node_in_group("player"):
		# If we have a player, do nothing
		print("Player found!")
		return
	
	print("No player found. Instantiating new player instance.")
	var player : Player = load("uid://cufevn3isam0a").instantiate()
	get_tree().root.add_child(player)
	# Position the player scene
	player.global_position = self.global_position	
	pass
