extends Control

const ROOM_SIZE := Vector2(640, 360) * 0.05
const OUTLINE_COLOR := Color.CYAN
const OUTLINE_WIDTH := 2.0
const PLAYER_MARKER_COLOR := Color.ORANGE
const PLAYER_MARKER_RADIUS := 4.0

func _ready() -> void:
	MapManager.map_changed.connect(queue_redraw)


func _draw() -> void:
	for coord in MapManager.discovered_rooms.keys():
		var color: Color = MapManager.discovered_rooms[coord]
		var pos := Vector2(coord) * ROOM_SIZE
		var rect := Rect2(pos, ROOM_SIZE)

		# fill room
		draw_rect(rect, color)

		# cyan outline
		draw_rect(rect, OUTLINE_COLOR, false, OUTLINE_WIDTH)

	# player marker (orange circle in current room)
	var current_pos := Vector2(MapManager.current_room) * ROOM_SIZE
	var center := current_pos + (ROOM_SIZE * 0.5)

	draw_circle(center, PLAYER_MARKER_RADIUS, PLAYER_MARKER_COLOR)
