class_name MechLoadout
extends Resource

enum LimbSlot {
	CORE,
	LEFT_ARM,
	RIGHT_ARM,
	LEFT_LEG,
	RIGHT_LEG
}

@export var core: MechPart
@export var left_arm: MechPart
@export var right_arm: MechPart
@export var left_leg: MechPart
@export var right_leg: MechPart

# each of these slots will hold an equipped part
var slots := {
	LimbSlot.CORE: null,
	LimbSlot.LEFT_ARM: null,
	LimbSlot.RIGHT_ARM: null,
	LimbSlot.LEFT_LEG: null,
	LimbSlot.RIGHT_LEG: null
}

const ARM_SLOTS = [LimbSlot.LEFT_ARM, LimbSlot.RIGHT_ARM]
const LEG_SLOTS = [LimbSlot.LEFT_LEG, LimbSlot.RIGHT_LEG]

func equip_part(part: MechPart) -> bool:
	match part.part_type:
		MechPart.PartType.CORE:
			return _equip_core(part)
		MechPart.PartType.LARM:
			return _equip_arm(part)
		MechPart.PartType.LLEG:
			return _equip_arm(part)
		MechPart.PartType.RARM:
			return _equip_arm(part)
		MechPart.PartType.RLEG:
			return _equip_leg(part)
	return false
	
func _equip_core(part : MechPart) -> bool:
	if slots[LimbSlot.CORE] != null:
		return false
	
	slots[LimbSlot.CORE] = EquippedPart.new(part)
	return true
	
func _equip_arm(part : MechPart) -> bool:
	if part.slot_size == part.SlotSize.SINGLE:
		for slot in ARM_SLOTS:
			if slots[slot] == null:
				slots[slot] = EquippedPart.new(part)
				return true
		
		return false
	
	if part.slot_size == part.SlotSize.DOUBLE:
		if slots[LimbSlot.LEFT_ARM] != null or slots[LimbSlot.RIGHT_ARM] != null:
			return false
			
		var equipped := EquippedPart.new(part)
		slots[LimbSlot.LEFT_ARM] = equipped
		slots[LimbSlot.RIGHT_ARM] = equipped
		return true
		
	return false
	
func _equip_leg(part : MechPart) -> bool:

	if part.slot_size == part.SlotSize.SINGLE:
		for slot in LEG_SLOTS:
			if slots[slot] == null:
				slots[slot] = EquippedPart.new(part)
				return true
		return false
		
	if part.slot_size == part.SlotSize.DOUBLE:
		if slots[LimbSlot.LEFT_LEG] != null or slots[LimbSlot.RIGHT_LEG] != null:
			return false
		
		var equipped := EquippedPart.new(part)
		slots[LimbSlot.LEFT_LEG] = equipped
		slots[LimbSlot.RIGHT_LEG] = equipped
		return true
		
	return false

func unequip_slot(slot : LimbSlot) -> MechPart:
	var equipped : EquippedPart = slots[slot]
	if equipped == null:
		return null
		
	var part := equipped.part
	
	for key in slots.keys():
		if slots[key] == equipped:
			slots[key] = null
	
	return part
	
func get_equipped(slot : LimbSlot) -> EquippedPart:
	return slots[slot]
	
func swap_part(slot: LimbSlot, new_part: MechPart) -> bool:
	var old:= unequip_slot(slot)
	
	if not equip_part(new_part):
		# if it fails
		if old != null:
			equip_part(old)
			
		return false
		
	return true
	
func get_all_parts() -> Array[MechPart]:
	var result : Array[MechPart] = []
	
	for s in slots.values():
		if s != null and s.part not in result:
			result.append(s.part)
			
	return result
	
func rebuild_runtime() -> void:
	slots.clear()

	if core:
		slots[LimbSlot.CORE] = EquippedPart.new(core)

	if left_arm:
		slots[LimbSlot.LEFT_ARM] = EquippedPart.new(left_arm)

	if right_arm:
		slots[LimbSlot.RIGHT_ARM] = EquippedPart.new(right_arm)

	if left_leg:
		slots[LimbSlot.LEFT_LEG] = EquippedPart.new(left_leg)

	if right_leg:
		slots[LimbSlot.RIGHT_LEG] = EquippedPart.new(right_leg)
