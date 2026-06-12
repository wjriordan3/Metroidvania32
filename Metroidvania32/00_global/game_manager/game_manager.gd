extends Node2D

# Sets all enemies and player process modes to disabled
func pause_entities():
	# Pause player
	for player in get_tree().get_nodes_in_group("player"):
		player.process_mode = Node.PROCESS_MODE_DISABLED

	# Pause enemies
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.process_mode = Node.PROCESS_MODE_DISABLED

# Resumes process mode for players and enemies
func unpause_entities():
	# Unpause player
	for player in get_tree().get_nodes_in_group("player"):
		player.process_mode = Node.PROCESS_MODE_INHERIT

	# Unpause enemies
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.process_mode = Node.PROCESS_MODE_INHERIT
