extends StaticBody2D

enum DoorType {
	PUNCH,
	KICK,
	DRILL,
	GUN,
	BUTTON,
	LOCK_OPEN,
	LOCK_CLOSED
}

# Punch door by default
@export var door_type = DoorType.PUNCH
@export var is_interactable = false

var is_open = false

@export var punch_door: SpriteFrames
@export var kick_door: SpriteFrames
@export var drill_door: SpriteFrames
@export var gun_door: SpriteFrames
@export var button_door: SpriteFrames
@export var lock_door: SpriteFrames

@onready var door_collision = $CollisionShape2D
@onready var door_sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

# Set sprite frames based on door type
func _ready() -> void:
	# Hide interaction for doors
	InteractionManager.visible = false
	
	match door_type:
		DoorType.PUNCH:
			door_sprite.sprite_frames = punch_door
		DoorType.KICK:
			door_sprite.sprite_frames = kick_door
		DoorType.DRILL:
			door_sprite.sprite_frames = drill_door
		DoorType.GUN:
			door_sprite.sprite_frames = gun_door
		DoorType.BUTTON:
			door_sprite.sprite_frames = button_door
		DoorType.LOCK_OPEN:
			door_collision.disabled = true
			door_sprite.sprite_frames = lock_door
			is_open = true
		DoorType.LOCK_CLOSED:
			door_sprite.sprite_frames = lock_door
			# set to open to show the door closed initially
			door_sprite.animation = "open"

	# Setup interactable door
	if is_interactable:
		interaction_area.interact = Callable(self, "_on_interact")
		# Uncomment to get button prompt
		# InteractionManager.visible = true

func _on_interact():
	# TODO check if player has key for special room
	# Only open door if it is closed
	if !is_open:
		print("Interact/key door open")
		open_door()

func open_door():
	door_sprite.play("open")
	door_collision.disabled = true
	is_open = true

# Only open lock doors can close
func close_door():
	if door_type == DoorType.LOCK_OPEN:
		door_collision.disabled = false
		door_sprite.play("close")
		is_open = false

# Door logic for limb doors
func _on_damage_area_damage_taken(attack_area: Variant) -> void:
	print("Door hit" + attack_area.name)
	
	# Check if correct limb was used
	if door_type == DoorType.PUNCH && attack_area.collision_layer == 10:
		print("Punch door open")
		open_door()
	elif door_type == DoorType.KICK && attack_area.collision_layer == 11:
		print("Kick door open")
		open_door()
	elif door_type == DoorType.DRILL && attack_area.collision_layer == 12:
		print("Drill door open")
		open_door()
	elif door_type == DoorType.GUN && attack_area.collision_layer == 13:
		print("Gun door open")
		open_door()
