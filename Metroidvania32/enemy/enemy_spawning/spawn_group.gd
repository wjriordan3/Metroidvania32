class_name SpawnGroup extends Resource

@export var enemy_scene: PackedScene

@export var count: int = 1

@export_range(0.0, 10.0, 0.1)
var spawn_interval: float = 0.2

@export var spawn_point_names: Array[String]

@export var randomize_spawn_points := true

enum PatternType {
	RANDOM,
	ROUND_ROBIN,
	LEFT_TO_RIGHT,
	RIGHT_TO_LEFT,
	BURST
}

@export var pattern_type: PatternType = PatternType.RANDOM
