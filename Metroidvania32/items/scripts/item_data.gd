class_name ItemData extends Resource

enum ItemType {
	CORE,
	LIMB,
	CONSUMABLE,
	CHIP,
	KEY,
	CURRENCY
}

@export var itemType : ItemType

@export var name : String = ""
@export_multiline var description : String = ""
@export var texture : Texture2D 

@export var quantity : int = 1

@export var IsKeyItem : bool = false

@export_category("Item Use Effects")
@export var effects : Array[ItemEffect]

func use() -> bool:
	if itemType != ItemType.CONSUMABLE:
		return false
	
	if effects.size() == 0:
		return false
	
	for e in effects:
		if e:
			e.use()
		
	return true

# from old version

@export var inventorySlot : String = "InventorySlots"  
@export var inventoryPosition: int 
