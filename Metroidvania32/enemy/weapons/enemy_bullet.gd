class_name EnemyBullet extends Node2D

const SPEED: int = 300

@onready var attack_area: AttackArea = $AttackArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_area.set_active(true)
	attack_area.area_entered.connect( _remove_bullet_on_hit )
	attack_area.body_entered.connect( _remove_bullet_on_hit )	
	pass # Replace with function body.

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _remove_bullet_on_hit(_area : Area2D) -> void:
	#print("Bullet hit @: ", _area)
	queue_free()
