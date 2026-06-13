extends Control

# Limb health thresholds
@export var caution_health = 50
@export var danger_health = 20

# Good limb textures
const good_arm = preload("res://ui/ui_resources/limb_ui/arm/good_arm.png")
const good_leg = preload("res://ui/ui_resources/limb_ui/leg/good_leg.png")
const good_body = preload("res://ui/ui_resources/limb_ui/body/good_body.png")

# Caution limb textures
const caution_arm = preload("res://ui/ui_resources/limb_ui/arm/caution_arm.png")
const caution_leg = preload("res://ui/ui_resources/limb_ui/leg/caution_leg.png")
const caution_body = preload("res://ui/ui_resources/limb_ui/body/caution_body.png")

# Danger limb textures
const danger_arm = preload("res://ui/ui_resources/limb_ui/arm/danger_arm.png")
const danger_leg = preload("res://ui/ui_resources/limb_ui/leg/danger_leg.png")
const danger_body = preload("res://ui/ui_resources/limb_ui/body/danger_body.png")

# Disabled limb textures
const disabled_arm = preload("res://ui/ui_resources/limb_ui/arm/disabled_arm.png")
const disabled_leg = preload("res://ui/ui_resources/limb_ui/leg/disabled_leg.png")
const disabled_body = preload("res://ui/ui_resources/limb_ui/body/disabled_body.png")

# Limbs
@onready var left_arm = $LeftArm
@onready var right_arm = $RightArm
@onready var left_leg = $LeftLeg
@onready var right_leg = $RightLeg
@onready var body = $Body

func _ready():
	Messages.player_health_changed.connect(_on_player_health_changed)

# Helper to get correct limb texture
func _get_limb_texture(
	health: int,
	good: Texture2D,
	caution: Texture2D,
	danger: Texture2D,
	disabled: Texture2D
) -> Texture2D:
	if health <= 0:
		return disabled
	elif health <= danger_health:
		return danger
	elif health <= caution_health:
		return caution
	return good

# Updating limb health sprites
func update_health(limb: Variant, health: int):
	var target_limb: Node
	var good_texture: Texture2D
	var caution_texture: Texture2D
	var danger_texture: Texture2D
	var disabled_texture: Texture2D

	match limb:
		"LEFT_ARM":
			target_limb = left_arm
			good_texture = good_arm
			caution_texture = caution_arm
			danger_texture = danger_arm
			disabled_texture = disabled_arm
		"RIGHT_ARM":
			target_limb = right_arm
			good_texture = good_arm
			caution_texture = caution_arm
			danger_texture = danger_arm
			disabled_texture = disabled_arm
		"LEFT_LEG":
			target_limb = left_leg
			good_texture = good_leg
			caution_texture = caution_leg
			danger_texture = danger_leg
			disabled_texture = disabled_leg
		"RIGHT_LEG":
			target_limb = right_leg
			good_texture = good_leg
			caution_texture = caution_leg
			danger_texture = danger_leg
			disabled_texture = disabled_leg

	target_limb.get_node("Sprite2D").texture = _get_limb_texture(
		health,
		good_texture,
		caution_texture,
		danger_texture,
		disabled_texture
	)

# For changing the body health
func _on_player_health_changed(hp: float, max_hp: float) -> void:
	if hp <= 0:
		body.get_node("Sprite2D").texture = disabled_body
	elif hp <= danger_health:
		body.get_node("Sprite2D").texture = danger_body
	elif hp <= caution_health:
		body.get_node("Sprite2D").texture = caution_body
	else:
		body.get_node("Sprite2D").texture = good_body
