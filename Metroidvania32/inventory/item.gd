extends Area2D

@export var itemName: String
@export var itemIcon: Texture 

var itemData: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = itemIcon 
	
	itemData = {
		"name": itemName,
		"icon": itemIcon  
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

#handle collision with the player character
#func _on_area_2d_body_entered(body: Node2D) -> void:
#	if body.is_in_group( "player" ):
#		print( "item collided" )
#		Inventory.pickup( self )


# The implementation below utilizes a "Signal" linking the _on_body_entered() event to the below function. Its accessible from cleaning up your Item work and setting it up as an Area2D
func _on_body_entered(body):
	if "Player" in body.name:
		print( "item collided" )
		#Inventory.pickup( self )
		var inventory = body.get_node_or_null("Inventory")

		if inventory:
			inventory.pickup(self)
			
		body.get_item(itemData)
		queue_free()
