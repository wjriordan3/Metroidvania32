extends Area2D
class_name Switch

enum SwitchType {
	GUN,
	KICK,
	BUTTON
}

# Button switch by default
@export var switch_type = SwitchType.BUTTON

@onready var switch_sprite = $AnimatedSprite2D

# SpriteFrame vars
@export var gun_switch: SpriteFrames
@export var kick_switch: SpriteFrames
@export var button_switch: SpriteFrames

# Inactive/off by default
var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match switch_type:
		SwitchType.GUN:
			switch_sprite.sprite_frames = gun_switch
		SwitchType.KICK:
			switch_sprite.sprite_frames = kick_switch
		SwitchType.BUTTON:
			switch_sprite.sprite_frames = button_switch

func _activate():
	active = true
	switch_sprite.play()
	Messages.switch_activated.emit(self)

# Button switch logic
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") && switch_type == SwitchType.BUTTON && !active:
		print("Button pressed" + body.name)
		_activate()

# Gun and kick switch logic
func _on_damage_area_damage_taken(attack_area: Variant) -> void:
	print("Button attacked" + attack_area.name)
	if switch_type == SwitchType.GUN && attack_area.collision_layer == 13:
		_activate()
	elif switch_type == SwitchType.KICK && attack_area.collision_layer == 11:
		_activate()
