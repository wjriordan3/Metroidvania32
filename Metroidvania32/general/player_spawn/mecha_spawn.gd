@icon( "res://general/icons/player_spawn.svg" )
class_name MechaSpawn extends Node2D

func _ready() -> void:
	visible = false
	
	await get_tree().process_frame
	# Check to see if we already have a mecha
	if get_tree().get_first_node_in_group("mecha"):
		print("Mecha found! Moving to spawn position at: ", global_position)
		PlayerManager.set_mecha_position( global_position )
	
	if PlayerManager.mecha_spawned == false:
		print("No mecha found. Instantiating new mecha instance.")
		PlayerManager.add_mecha_instance()
		print("Now moving mecha")
		PlayerManager.set_mecha_position( global_position )
		PlayerManager.mecha_spawned = true
