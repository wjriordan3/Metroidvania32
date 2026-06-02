class_name InventoryData extends Resource

signal new_item(item: Object)

@export var slots : Array[ SlotData ]

func add_item( item : ItemData, quantity : int = 1) -> bool:
	# Check if item exists in inventory
	for s in slots:
		if s:
			if s.item_data == item:
				s.quantity += quantity
				return true
	
	for i in slots.size():
		if slots[ i ] == null:
			var new = SlotData.new()
			new.item_data = item
			new.quantity = quantity
			slots[ i ] = new
			return true
			
	return false
	
# For adding item from world to bag slots
#func add_item(item:Item):
#	item.inventorySlot = "BagSlots"
#	item.inventoryPosition = _get_next_empty_bag_slot()
	
#	item.add(item.resource.path)
