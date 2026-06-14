extends Control

const ROOM_SIZE := Vector2(24, 16)
const CHUNK_W := 4
const CHUNK_H := 3

@export var room_texture: Texture2D

@onready var minimap_area: Control = $MinimapArea
@onready var room_container: Control = $MinimapArea/Room
@onready var player_room: TextureRect = $MinimapArea/PlayerRoom

var room_lookup: Dictionary = {}
var current_chunk := Vector2i(0, 0)

func _ready() -> void:
	player_room.size = ROOM_SIZE
	minimap_area.clip_contents = true
	MapManager.map_changed.connect(_update_minimap)
	_update_minimap()

func _room_to_chunk(pos: Vector2i) -> Vector2i:
	return Vector2i(
		floor(pos.x / CHUNK_W),
		floor(pos.y / CHUNK_H)
	)

func _build_rooms() -> void:
	for child in room_container.get_children():
		child.queue_free()

	room_lookup.clear()

	var start_x = current_chunk.x * CHUNK_W
	var start_y = current_chunk.y * CHUNK_H

	# Build 4x3 grid in local space
	for y in range(CHUNK_H):
		for x in range(CHUNK_W):
			var coord := Vector2i(start_x + x, start_y + y)

			if not MapManager.discovered_rooms.has(coord):
				continue

			var room := TextureRect.new()
			room.texture = room_texture
			room.size = ROOM_SIZE
			room.position = Vector2(x, y) * ROOM_SIZE
			room_container.add_child(room)
			room_lookup[coord] = room

func _update_minimap() -> void:
	current_chunk = _room_to_chunk(MapManager.current_room)
	_build_rooms()

	# Local position in 4x3 grid
	var local := Vector2(
		MapManager.current_room.x % CHUNK_W,
		MapManager.current_room.y % CHUNK_H
	)
	player_room.position = local * ROOM_SIZE
	# No container shift
	room_container.position = Vector2.ZERO
