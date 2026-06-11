class_name MechPart extends ItemData

enum PartType {
	CORE,
	LARM,
	LLEG,
	RARM,
	RLEG
}

enum SlotSize {
	SINGLE,
	DOUBLE
}

@export_category("Mech Part")
## What category of part this is.
## Used for equip validation.
@export var part_type : PartType
@export var slot_size : SlotSize = SlotSize.SINGLE

## Base durability for this part.
## Runtime health should NOT be stored here.
@export var max_health : int

## Stat modifiers contributed by this part.
@export var attack_power : int = 0
@export var defense : int = 0
@export var movement_speed_bonus : float = 0.0

## In case we want mechs to use a weight system.
@export var weight : float = 0.0

## Actual animation frames
@export var sprite_frames : SpriteFrames
## Animations for this part
@export var animation_set : MechPartAnimations

@export_category("Abilities")

## Abilities granted by this part
@export var abilities: Array[MechAbility]

## Special ability states unlocked by this part
@export var ability_states: Array[PackedScene]

## Passive effects
@export var passive_effects: Array[MechPassive]
