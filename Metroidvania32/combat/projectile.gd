extends Node2D

const SPEED = 300

func _ready() -> void :
	$AttackArea.set_active( true )

func _process(delta):
	position += transform.x * SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$AttackArea.set_active( false )
	queue_free()
