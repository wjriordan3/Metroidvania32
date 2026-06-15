extends Node2D

@export var fuse_time: float = 3.0

@onready var bomb_sprite = $Bomb
@onready var explosion = $Explosion
@onready var attack_area: Area2D = $AttackArea

func _ready() -> void:
	attack_area.monitoring = false
	await get_tree().create_timer(fuse_time).timeout
	explode()


func explode() -> void:
	bomb_sprite.visible = false
	explosion.visible = true
	explosion.play()
	attack_area.monitoring = true

	# Delete bomb from scene
	await explosion.animation_finished
	queue_free()
