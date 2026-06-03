class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://pause_menu/inventory/inventory_slot.tscn")

var focus_index : int = 0

@export var data : InventoryData

@onready var pause_menu: CanvasLayer = $"../../../../.."

# we set up the inventory here as a control so we can utilize it for the player's UI/HUD later on. Below you'll see variables setup for the equipment slots...
@onready var inventory_slots: GridContainer = $"."
@onready var equipment_left_arm: GridContainer = $"../../LoadoutContainer/EquipmentLeftArm"
@onready var equipment_right_arm: GridContainer = $"../../LoadoutContainer/EquipmentRightArm"
@onready var equipment_core: GridContainer = $"../../LoadoutContainer/EquipmentCore"
@onready var equipment_left_leg: GridContainer = $"../../LoadoutContainer/EquipmentLeftLeg"
@onready var equipment_right_leg: GridContainer = $"../../LoadoutContainer/EquipmentRightLeg"

var inventoryDict = {}

func _ready() -> void:
	pause_menu.pause_screen_shown.connect( update_inventory )
	pause_menu.pause_screen_hidden.connect( clear_inventory )
	clear_inventory()
	
	data.changed.connect( on_inventory_changed )
	
	inventoryDict = {
		"InventorySlots": inventory_slots,
		"EquipmentLeftArm": equipment_left_arm,
		"EquipmentRightArm": equipment_right_arm,
		"EquipmentLeftLeg": equipment_left_leg,
		"EquipmentRightLeg": equipment_right_leg,
		"EquipmentCore": equipment_core
	}
	
	#_refresh_ui()
	pass
	
func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()
		
func update_inventory( i : int = 0 ) -> void:
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child( new_slot )
		new_slot.slot_data = s
		new_slot.focus_entered.connect( item_focused ) 
	
	await get_tree().process_frame
	get_child( i ).grab_focus()	
	
	
func on_inventory_changed() -> void:
	var i = focus_index
	clear_inventory()
	update_inventory( i )
	pass
	
func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return
	pass

#region Drag Drop Functions
func _get_drag_data(at_position):
	var dragSlotNode = get_slot_node_at_position(at_position)
	
	if dragSlotNode == null or dragSlotNode.texture == null: return
	
	var dragPreviewNode = dragSlotNode.duplicate()
	dragPreviewNode.custom_minimum_size = Vector2(60, 60)
	set_drag_preview(dragPreviewNode)
	
	return dragSlotNode
	
func _can_drop_data(at_position, _data):
	var targetSlotNode = get_slot_node_at_position(at_position)
	
	return targetSlotNode != null
	
func _drop_data(at_position, dragSlotNode):
	var targetSlotNode = get_slot_node_at_position(at_position)
	var _targetTexture = targetSlotNode.texture
	var targetResource = targetSlotNode.itemResource
	
	targetSlotNode.set_new_data(dragSlotNode.itemResource)
	dragSlotNode.set_new_data(targetResource)

func get_slot_node_at_position(_pos):
	var allSlotNodes = (
		inventory_slots.get_children() + equipment_core.get_children() + 
		equipment_left_arm.get_children() + equipment_right_arm.get_children() +
		equipment_left_leg.get_children() + equipment_right_leg.get_children())	
		
	for node in allSlotNodes:
		var nodeRect = node.get_global_rect()
		
		if nodeRect.has_point(position): return node

#endregion


# For adding item from world to bag slots
#func add_item(item:Item):
#	item.inventorySlot = "InventorySlots"
#	item.inventoryPosition = _get_next_empty_bag_slot()
	
#	item.add(item.resource.path)
	
func _get_next_empty_bag_slot():
	for slot in inventoryDict["InventorySlots"].get_children():
		if slot.texture == null:
			var slotNumber = int(slot.name.split("Slot")[1])
			return slotNumber

# TODO: update with new inventory data setup
func _refresh_ui():
	for item in data:
		print(item)
		item = load(item)

		var inventorySlot = item["inventorySlot"]
		var inventoryPosition = item["inventoryPosition"]
		var _icon = item["icon"]
		
		for slot in inventoryDict[inventorySlot].get_children():
			var slotNumber = int(slot.name.split("Slot")[1])
			
			if slotNumber == inventoryPosition:
				slot.set_new_data(item)
				
