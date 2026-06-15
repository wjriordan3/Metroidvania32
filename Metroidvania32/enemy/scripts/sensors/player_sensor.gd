class_name PlayerSensor extends Node


var player : CharacterBody2D

signal target_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print( "ready called")
	if not player:
		#print( len( get_tree().get_nodes_in_group("player")))
		for child in get_tree().get_nodes_in_group( "player" ) :
			if child is Player :
				player = child
				print( "Player found" )
			#print( "player found")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not player :
		#print( len( get_tree().get_nodes_in_group("player")))
		for child in get_tree().get_nodes_in_group( "player" ) :
			if child is Player or child is MechaUnit:
				player = child
				print( "Player found" )
	else:
		if player is Player:
			if not player.activePlayer :
				player = null
				target_changed.emit()
				print( "entered mech")
		if player is MechaUnit :
			if not player.is_in_group( "player" ) :
				player = null
				target_changed.emit()
				print( "exited mech" )
	pass
