extends Node

# 5x5 grid, 20 backpack slots, 5 equipped
# leftarm=[4][0], leftleg=[4][1], core=[4][2], rightleg=[4][3], rightarm=[4][4]
# equipment mirrored ordering left to right to make GUI placement more logical
func _init() -> void :
	self.contents = \
	[
		[null, null, null, null, null],
		[null, null, null, null, null],
		[null, null, null, null, null],
		[null, null, null, null, null],
		[null, null, null, null, null]
	]

#Called when the player walks over an item in the world
#Inputs
#item : Object - The target item
func pickup( item : Object ) -> void :
	for row in self.contents:
		for col in self.contents[row] :
			if not self.contents[row][col] :
				print( item.to_string() )
				print( "item added to inventory at {row},{col}"  )
				self.contents[row][col] = item
				return
	print( "no space for item!" )

#Called when the player selects "drop" with an inventory cell highlighted
#Inputs
#x : int - The x position of the highlighted cell
#y : int - The y position of the highlighted cell

#Returns 
#item : Object - The selected item to be passed accordingly (eg. placed into the world or sent to workshop table)
func drop( x : int, y : int ):
	var item : Object = self.contents[x][y]
	self.contents[x][y] = null
	print( item.to_string() )
	return item
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
