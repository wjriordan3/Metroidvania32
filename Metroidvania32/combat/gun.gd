extends Node2D

const PROJECTILE = preload("res://combat/projectile.tscn")
@onready var marker_2d = $Marker2D

func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("fire"):
		var projectile_instance = PROJECTILE.instantiate()
		get_tree().root.add_child(projectile_instance)
		projectile_instance.global_position = marker_2d.global_position 
		projectile_instance.global_rotation = global_rotation
