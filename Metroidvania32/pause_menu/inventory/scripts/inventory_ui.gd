class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://pause_menu/inventory/inventory_slot.tscn")

var focus_index : int = 0
var hovered_item : InventorySlotUI = null

@export var data : InventoryData

@onready var pause_menu: CanvasLayer = $"../../../../.."

@onready var inventory_slot_left_leg: InventorySlotUI = %InventorySlot_LeftLeg
@onready var inventory_slot_left_arm: InventorySlotUI = %InventorySlot_LeftArm
@onready var inventory_slot_core: InventorySlotUI = %InventorySlot_Core
@onready var inventory_slot_right_arm: InventorySlotUI = %InventorySlot_RightArm
@onready var inventory_slot_right_leg: InventorySlotUI = %InventorySlot_RightLeg

var inventoryDict = {}

func _ready() -> void:
	pause_menu.pause_screen_shown.connect( update_inventory )
	pause_menu.pause_screen_hidden.connect( clear_inventory )
	clear_inventory()
	data.changed.connect( on_inventory_changed )
	data.equipment_changed.connect( on_inventory_changed )
	pass
	
func clear_inventory() -> void:
	for c in get_children():
		c.set_slot_data( null )
		
func update_inventory( apply_focus : bool = true ) -> void:
	clear_inventory()
	
	var inv_slots : Array[ SlotData ] = data.get_inventory_slots()
	
	for i in inv_slots.size():
		var slot : InventorySlotUI = get_child(i)
		slot.set_slot_data( inv_slots[ i ])
		connect_item_signals( slot )
		
	# update equipment slots
	var e_slots : Array[ SlotData ] = data.get_equipment_slots()
	inventory_slot_left_leg.set_slot_data(e_slots[ 0 ])
	inventory_slot_left_arm.set_slot_data(e_slots[ 1 ])
	inventory_slot_core.set_slot_data(e_slots[ 2 ])
	inventory_slot_right_arm.set_slot_data(e_slots[ 3 ])
	inventory_slot_right_leg.set_slot_data(e_slots[ 4 ])
	
	if apply_focus:
		get_child( 0 ).grab_focus()	
	
func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return
	pass

func on_inventory_changed() -> void:
	update_inventory( false )
	pass
	
func connect_item_signals( item : InventorySlotUI ) -> void:
	if not item.button_up.is_connected(on_item_drop):
		item.button_up.connect(on_item_drop.bind(item))
		
	if not item.mouse_entered.is_connected(on_item_mouse_entered):
		item.mouse_entered.connect(on_item_mouse_entered.bind(item))
	
	if not item.mouse_exited.is_connected(on_item_mouse_exited):
		item.mouse_exited.connect(on_item_mouse_exited)
	
	pass
	
func on_item_drop( item: InventorySlotUI ) -> void:
	
	print("item dropped", item.name)
	pass
	
func on_item_mouse_entered( item : InventorySlotUI ) -> void:
	hovered_item = item
	print("item mouse entered", item.name)
	pass
	
func on_item_mouse_exited() -> void:
	hovered_item = null
	print("item mouse exited")
	pass
