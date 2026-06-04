class_name AbilityStateGun extends AbilityState

@export var duration : float = 0.2 # for a firing animation
@export var projectile_scene : PackedScene
@export var muzzle_node_path: NodePath # marker2d for bullet spawning
@export var shots_per_second : float = 5.0
@export var rotate_sprite: bool = true
@export var default_fire_angle_offset: float = 0.0 # could adjust if needed

var timer : float = 0.0
var shot_timer : float = 0.0

func enter() -> void:
	timer = duration
	shot_timer = 0.0	
	
	# add mech hooks below
	# mecha.play_animation("gun_fire")
	
func exit() -> void:
	# mecha.set_drill_active(false)
	pass
	
func physics_process( delta: float) -> AbilityState:
	# start timer
	timer -= delta
	shot_timer -= delta 
	
	var muzzle = mecha.get_node_or_null(muzzle_node_path)
	if muzzle == null or projectile_scene == null:
		return state_machine.get_state("None")
		
	# check aim direction
	var aim_dir := mecha.get_aim_direction() # from mechaunit
	var is_aiming : bool = aim_dir.length() > 0.2
	
	# Rotate sprite if aiming
	if rotate_sprite and is_aiming:
		muzzle.get_parent().rotation = aim_dir.angle
		# optional sprite flip
		if muzzle.get_parent().rotation_degrees > 90 and muzzle.get_parent().rotation_degrees < 270:
			muzzle.get_parent().scale.y = -1
		else:
			muzzle.get_parent().scale.y = 1
	elif not is_aiming:
		# Default to mech facing
		var facing_dir := Vector2.RIGHT if aim_dir.x >= 0 else Vector2.LEFT
		
		muzzle.get_parent().rotation = facing_dir.angle()
		muzzle.get_parent().scale.y = 1 if facing_dir.x >= 0 else -1

	# Fire bullets
	if shot_timer <= 0.0:
		fire_bullet(muzzle.global_position, muzzle.global_rotation)
		shot_timer = 1.0 / shots_per_second

	# End ability state when duration is over
	if timer <= 0.0:
		return state_machine.get_state("None")

	return null

func fire_bullet(position: Vector2, rotation: float) -> void:
	var bullet = projectile_scene.instantiate()
	mecha.get_tree().root.add_child(bullet)
	bullet.global_position = position
	bullet.rotation = rotation + default_fire_angle_offset
	
