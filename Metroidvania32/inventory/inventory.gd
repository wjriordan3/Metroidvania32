extends Control 

# we set up the inventory here as a control so we can utilize it for the player's UI/HUD later on. Below you'll see variables setup for the equipment slots...
@onready var bag_slots: GridContainer = $TextureRect/BagSlots
@onready var equipment_left_arm: GridContainer = $TextureRect/EquipmentLeftArm
@onready var equipment_right_arm: GridContainer = $TextureRect/EquipmentRightArm
@onready var equipment_core: GridContainer = $TextureRect/EquipmentCore
@onready var equipment_left_leg: GridContainer = $TextureRect/EquipmentLeftLeg
@onready var equipment_right_leg: GridContainer = $TextureRect/EquipmentRightLeg

var inventoryDict = {}

var items = ["res://inventory/itemresources/DrillArm.tres", "res://inventory/itemresources/PropellerLegs.tres"]

#region Drag Drop Functions
func _get_drag_data(at_position):
	var dragSlotNode = get_slot_node_at_position(at_position)
	
	if dragSlotNode == null or dragSlotNode.texture == null: return
	
	var dragPreviewNode = dragSlotNode.duplicate()
	dragPreviewNode.custom_minimum_size = Vector2(60, 60)
	set_drag_preview(dragPreviewNode)
	
	return dragSlotNode
	
func _can_drop_data(at_position, data):
	var targetSlotNode = get_slot_node_at_position(at_position)
	
	return targetSlotNode != null
	
func _drop_data(at_position, dragSlotNode):
	var targetSlotNode = get_slot_node_at_position(at_position)
	var targetTexture = targetSlotNode.texture
	var targetResource = targetSlotNode.itemResource
	
	targetSlotNode.set_new_data(dragSlotNode.itemResource)
	dragSlotNode.set_new_data(targetResource)

func get_slot_node_at_position(position):
	var allSlotNodes = (
		bag_slots.get_children() + equipment_core.get_children() + 
		equipment_left_arm.get_children() + equipment_right_arm.get_children() +
		equipment_left_leg.get_children() + equipment_right_leg.get_children())	
		
	for node in allSlotNodes:
		var nodeRect = node.get_global_rect()
		
		if nodeRect.has_point(position): return node

#endregion

# For adding item from world to bag slots
func add_item(item:Item):
	item.inventorySlot = "BagSlots"
	item.inventoryPosition = _get_next_empty_bag_slot()
	
	item.add(item.resource.path)
	
func _get_next_empty_bag_slot():
	for slot in inventoryDict["BagSlots"].get_children():
		if slot.texture == null:
			var slotNumber = int(slot.name.split("Slot")[1])
			return slotNumber

func get_item(itemData):
	items.append(itemData)
	# Need to refresh UI upon getting item
	#_refresh_ui()

func _refresh_ui():
	for item in items:
		print(item)
		item = load(item)

		var inventorySlot = item["inventorySlot"]
		var inventoryPosition = item["inventoryPosition"]
		var icon = item["icon"]
		
		for slot in inventoryDict[inventorySlot].get_children():
			var slotNumber = int(slot.name.split("Slot")[1])
			
			if slotNumber == inventoryPosition:
				slot.set_new_data(item)

var contents : Array
# 5x5 grid, 20 backpack slots, 5 equipped
# leftarm=[4][0], leftleg=[4][1], core=[4][2], rightleg=[4][3], rightarm=[4][4]
# equipment mirrored ordering left to right to make GUI placement more logical
func _init() -> void :
	contents = \
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
	for row in self.contents.size() :
		for col in self.contents[row].size() :
			if not self.contents[row][col]:
				print( item.to_string() )
				print( "item added to inventory at ", row, ", ", col )
				self.contents[row][col] = item
				print( "confirm: [", row, "][", col, "] = ", self.contents[row][col].to_string() )
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
	_init()
	visible = false # Hiding inventory UI on game start
	inventoryDict = {
		"BagSlots": bag_slots,
		"EquipmentLeftArm": equipment_left_arm,
		"EquipmentRightArm": equipment_right_arm,
		"EquipmentLeftLeg": equipment_left_leg,
		"EquipmentRightLeg": equipment_right_leg,
		"EquipmentCore": equipment_core
	}
	
	_refresh_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
