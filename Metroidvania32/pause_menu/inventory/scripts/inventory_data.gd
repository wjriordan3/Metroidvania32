class_name InventoryData extends Resource

signal equipment_changed

@export var scrap = 150
signal add_scrap(scrap: int)
signal new_item(item: Object)

@export var slots : Array[ SlotData ]
var equipment_slot_count : int = 5

func _init() -> void:
	connect_slots()
	
func get_inventory_slots() -> Array[ SlotData ]:
	return slots.slice(0, -equipment_slot_count)

func get_equipment_slots() -> Array[ SlotData ]:
	return slots.slice(-equipment_slot_count, slots.size())

func add_item( item : ItemData ) -> bool:
	
	# Item obtained is scrap (currency), do not add to inventory
	if item.name == "Scrap":
		scrap += item.quantity
		add_scrap.emit(scrap)
		return true
	
	# Check if item exists in inventory
	for s in slots:
		if s:
			if s.item_data == item:
				s.quantity += item.quantity
				new_item.emit(s.item_data)
				return true
	
	for i in get_inventory_slots().size():
		if slots[ i ] == null:
			var new = SlotData.new()
			new.item_data = item
			new.quantity = item.quantity
			slots[ i ] = new
			new.changed.connect( slot_changed )
			new_item.emit(new.item_data)
			return true
	
	print("Inventory full!")
	return false

func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect( slot_changed )
	pass
	
func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect( slot_changed )
				var index = slots.find( s )
				slots [ index ] = null
				emit_changed()
	pass
	
func swap_items_by_index( i1 : int, i2 : int ) -> void:
	var temp : SlotData = slots[ i1 ]
	slots[ i1 ] = slots[ i2 ]
	slots[ i2 ] = temp
	pass

func equip_item( slot : SlotData ) -> void:
	if slot == null or not slot.item_data is MechPart:
		return
	
	var item : MechPart = slot.item_data
	var slot_index : int = slots.find( slot )
	var equipment_index : int = slots.size() - equipment_slot_count # 28
	
	match item.part_type:
		MechPart.PartType.LLEG:
			equipment_index += 0
			pass
		MechPart.PartType.LARM:
			equipment_index += 1
			pass
		MechPart.PartType.CORE:
			equipment_index += 2
			pass
		MechPart.PartType.RARM:
			equipment_index += 3
			pass
		MechPart.PartType.RLEG:
			equipment_index += 4
			pass
			
	var unequipped_slot : SlotData = slots[ equipment_index ]
	
	slots[ slot_index ] = unequipped_slot
	slots[ equipment_index ] = slot
	
	equipment_changed.emit()
	PauseMenu.focused_item_changed(unequipped_slot)
	pass
	
# Gather the inventory data into an array
func get_save_data() -> Array:
	var items_to_save : Array = []
	for i in slots.size():
		items_to_save.append( item_to_save( slots[i] ) )
	return items_to_save

# Convert each inventory item into a dictionary
func item_to_save( slot : SlotData ) -> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null: 
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result	

func parse_save_data( save_data : Array ) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize( array_size )
	for i in save_data.size():
		slots[ i ] = item_from_save( save_data[i] )
	connect_slots()

func item_from_save( save_object : Dictionary ) -> SlotData:
	if save_object.item == "":
		return null
	var new_slot : SlotData = SlotData.new()
	new_slot.item_data = load( save_object.item ) 
	new_slot.quantity = int( save_object.quantity )
	return new_slot
	
