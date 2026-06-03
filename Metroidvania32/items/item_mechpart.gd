class_name MechPart extends ItemData

enum LimbSlot {
	CORE,
	LEFT_ARM,
	RIGHT_ARM,
	LEFT_LEG,
	RIGHT_LEG
}

@export var limb_slot: LimbSlot

@export var animation_set: SpriteFrames

# animation mapping
@export var animations := {
	"idle": "",
	"run": "",
	"jump": "",
	"hang": "",
	"action": ""
}
