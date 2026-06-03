extends Node2D

const BULLET = preload("res://combat/bullet.tscn")
const AIM_DEADZONE := 0.2
var last_aim_direction := Vector2.RIGHT

@onready var muzzle: Marker2D = $Marker2D

func _process(_delta : float) -> void:

	update_aim()
	update_sprite_flip()
	if Input.is_action_just_pressed("fire"):
		fire_bullet()
	

func update_aim() -> void:
	# Get aim input from right stick	
	var aim := Input.get_vector(
		"aim_left",
		"aim_right",
		"aim_up",
		"aim_down"
	)
	# Ignore tiny movements
	if aim.length() > AIM_DEADZONE:
		last_aim_direction = aim.normalized()
		rotation = last_aim_direction.angle()
	else:
		# Fall back to mouse aiming
		var mouse_direction := global_position.direction_to(
			get_global_mouse_position()
		)

		if mouse_direction.length() > 0:
			last_aim_direction = mouse_direction
			rotation = mouse_direction.angle()

func update_sprite_flip() -> void:
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	var angle_deg = rotation_degrees
	
	if angle_deg > 90.0 and angle_deg < 270.0:
		scale.y = -1
	else:
		scale.y = 1

func fire_bullet() -> void:
	var bullet_instance := BULLET.instantiate()

	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.rotation = rotation
	
