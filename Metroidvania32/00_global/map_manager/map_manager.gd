extends Node

signal map_changed

var discovered_rooms: Dictionary = {}
var current_room: Vector2i = Vector2i.ZERO

func discover_room(coord: Vector2i, color: Color) -> void:
	discovered_rooms[coord] = color
	current_room = coord
	map_changed.emit()
