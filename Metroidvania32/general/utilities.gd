class_name GameUtils

static func lerp_angle_short(a: float, b: float, t: float) -> float:
	return lerp_angle(a, b, t)
	
static func inverse_lerp(a: float, b: float, v: float) -> float:
	if a == b:
		return 0.0
	return (v - a) / (b - a)
	
static func clamp01(v: float) -> float:
	return clamp(v, 0.0, 1.0)

static func move_towards(current: Vector2, target: Vector2, max_distance: float) -> Vector2:
	var dir = target - current
	if dir.length() <= max_distance:
		return target
	return current + dir.normalized() * max_distance

static func approach(current: float, target: float, delta: float) -> float:
	if current < target:
		return min(current + delta, target)
	return max(current - delta, target)
	
static func snap_to_screen(pos: Vector2, screen_size: Vector2) -> Vector2:
	return (floor(pos / screen_size) * screen_size) + screen_size / 2
	
static func world_to_screen_cell(pos: Vector2, cell_size: Vector2) -> Vector2:
	return floor(pos / cell_size)
	
static func is_point_in_rect(point: Vector2, rect: Rect2) -> bool:
	return rect.has_point(point)

static func direction_to(a: Vector2, b: Vector2) -> Vector2:
	return (b - a).normalized()
	
static func angle_to(a: Vector2, b: Vector2) -> float:
	return (b - a).angle()

static func vector_from_angle(angle: float) -> Vector2:
	return Vector2.RIGHT.rotated(angle)
	
static func rand_bool(chance := 0.5) -> bool:
	return randf() < chance
	
static func rand_sign() -> int:
	return -1 if randf() < 0.5 else 1

static func rand_range_vec2(min_v: Vector2, max_v: Vector2) -> Vector2:
	return Vector2(
		randf_range(min_v.x, max_v.x),
		randf_range(min_v.y, max_v.y)
	)
	
static func lerp_vec2(a: Vector2, b: Vector2, t: float) -> Vector2:
	return a.lerp(b, t)
	
static func wait_frames(count: int) -> void:
	for i in count:
		await Engine.get_main_loop().process_frame
