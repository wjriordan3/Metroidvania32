extends TextureRect

@export var itemResource: Item

func set_new_data(resource: Item):
	itemResource = resource 
	
	texture = itemResource.icon
	
	if itemResource != null:
		itemResource.inventorySlot = get_parent().name
		itemResource.inventoryPosition = int(name.split("Slot")[1])
	else:
		texture = null
