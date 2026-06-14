extends StaticBody2D

enum LevelType {
	ROOFS,
	SECURITY,
	OFFICE,
	VIP,
	CASINO,
	VAULT
}

enum TileType {
	WALL,
	FLOOR
}

@export var level_type: LevelType = LevelType.ROOFS
@export var tile_type: TileType = TileType.WALL

# Hit and collision box adjustables
@export var physics_collision_height_percentage: float = 1.0
@export var damage_collision_height_percentage: float = 1.0

const ROOF_WALL_TILE = preload("res://level/breakable_level/assets/roofs/roofs_wall_breakable.png")
const ROOF_FLOOR_TILE = preload("res://level/breakable_level/assets/roofs/roofs_floor_breakable.png")

const SECURITY_WALL_TILE = preload("res://level/breakable_level/assets/security/security_wall_breakable.png")
const SECURITY_FLOOR_TILE = preload("res://level/breakable_level/assets/security/security_floor_breakable.png")

const OFFICE_WALL_TILE = preload("res://level/breakable_level/assets/office/office_wall_breakable.png")
const OFFICE_FLOOR_TILE = preload("res://level/breakable_level/assets/office/office_floor_breakable.png")

const VIP_WALL_TILE = preload("res://level/breakable_level/assets/vip/vip_wall_breakable.png")
const VIP_FLOOR_TILE = preload("res://level/breakable_level/assets/vip/vip_floor_breakable.png")

const CASINO_WALL_TILE = preload("res://level/breakable_level/assets/casino/casino_wall_breakable.png")
const CASINO_FLOOR_TILE = preload("res://level/breakable_level/assets/casino/casino_floor_breakable.png")

const VAULT_WALL_TILE = preload("res://level/breakable_level/assets/vault/vault_wall_breakable.png")
const VAULT_FLOOR_TILE = preload("res://level/breakable_level/assets/vault/vault_floor_breakable.png")

var is_broken := false

@onready var sprite: Sprite2D = $Sprite2D
@onready var body_collision: CollisionShape2D = $CollisionShape2D
@onready var damage_collision: CollisionShape2D = $DamageArea/CollisionShape2D

func _ready() -> void:
	sprite.texture = _get_tile_texture()
	_resize_collisions_to_sprite()

func _get_tile_texture() -> Texture2D:
	match level_type:
		LevelType.ROOFS:
			match tile_type:
				TileType.WALL:
					return ROOF_WALL_TILE
				TileType.FLOOR:
					return ROOF_FLOOR_TILE

		LevelType.SECURITY:
			match tile_type:
				TileType.WALL:
					return SECURITY_WALL_TILE
				TileType.FLOOR:
					return SECURITY_FLOOR_TILE

		LevelType.OFFICE:
			match tile_type:
				TileType.WALL:
					return OFFICE_WALL_TILE
				TileType.FLOOR:
					return OFFICE_FLOOR_TILE

		LevelType.VIP:
			match tile_type:
				TileType.WALL:
					return VIP_WALL_TILE
				TileType.FLOOR:
					return VIP_FLOOR_TILE

		LevelType.CASINO:
			match tile_type:
				TileType.WALL:
					return CASINO_WALL_TILE
				TileType.FLOOR:
					return CASINO_FLOOR_TILE

		LevelType.VAULT:
			match tile_type:
				TileType.WALL:
					return VAULT_WALL_TILE
				TileType.FLOOR:
					return VAULT_FLOOR_TILE

	return ROOF_WALL_TILE

func _resize_collisions_to_sprite() -> void:
	if sprite.texture == null:
		return

	var original_size := sprite.texture.get_size() * sprite.scale

	var offset_y: float

	var physics_size := original_size
	physics_size.y *= physics_collision_height_percentage
	offset_y = (original_size.y - physics_size.y) * 0.5

	if body_collision.shape is RectangleShape2D:
		body_collision.shape.size = physics_size
		body_collision.position.y = offset_y

	var damage_size := original_size
	damage_size.y *= damage_collision_height_percentage
	offset_y = (original_size.y - damage_size.y) * 0.5

	if damage_collision.shape is RectangleShape2D:
		damage_collision.shape.size = damage_size
		damage_collision.position.y = offset_y

func break_tile() -> void:
	if is_broken:
		return

	is_broken = true

	VisualEffects.explosion(global_position)

	visible = false
	body_collision.set_deferred("disabled", true)
	damage_collision.set_deferred("disabled", true)

func _on_damage_area_damage_taken(attack_area: Variant) -> void:
	if is_broken:
		return

	# Uses drill collision layer
	if attack_area.get_collision_layer_value(12):
		break_tile()
