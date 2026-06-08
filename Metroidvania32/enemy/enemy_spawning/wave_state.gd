extends RefCounted
class_name WaveState

signal cleared
var remaining := 0

func register_enemy(enemy: Node) -> void:
	remaining += 1
	enemy.died.connect(_on_enemy_died)

func _on_enemy_died() -> void:
	remaining -= 1
	if remaining <= 0:
		cleared.emit()
