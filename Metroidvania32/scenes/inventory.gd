extends Node

class Inventory:
	
	func _init() -> void:
		self.contents = []
		self.equipped = {
			"RightArm":null,
			"LeftArm":null,
			"RightLeg":null,
			"LeftLeg":null
		}
		
	func add( item: Node ) -> void:
		if len(self.contents) <= 10:
			self.contents.append( item )
	
	func remove( item: Node ) -> void:
		if self.contents.has( item ):
			self.contents.remove_at( self.contents.find( item ))
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
