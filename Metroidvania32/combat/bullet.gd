class_name Bullet extends Node2D
@onready var attack_area : AttackArea = $AttackArea

const SPEED: int = 300
func _ready() -> void :
	attack_area.set_active()

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
