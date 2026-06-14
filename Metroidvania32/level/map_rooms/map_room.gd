extends Area2D
class_name MapRoom

@export var map_coord: Vector2i
@export var room_color: Color = Color.CYAN

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		MapManager.discover_room(map_coord, room_color)
