extends Node2D

const PROJECTILE = preload("res://combat/projectile.tscn")
@onready var marker_2d = $Marker2D

var canFire = false

func _ready() -> void:
	visible = false
	pass

func _process(delta):
	if canFire:
		look_at(get_global_mouse_position())
		
		if Input.is_action_just_pressed("fire"):
			var projectile_instance = PROJECTILE.instantiate()
			get_tree().root.add_child(projectile_instance)
			projectile_instance.global_position = marker_2d.global_position 
			projectile_instance.global_rotation = global_rotation
