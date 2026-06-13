class_name EnemyGun extends Marker2D

# Gun represents a weapon that spawns and shoots bullets
# The cooldown timer controls the cooldown duration between shots

const BULLET_VELOCITY = 850.0
const BULLET_SCENE = preload("res://enemy/weapons/enemy_bullet.tscn")

enum FiringMode { GRUNT, TANK, BOSS }

@export var firing_mode : FiringMode

@onready var sound_shoot := $Shoot as AudioStreamPlayer2D
@onready var timer := $Timer as Timer 
var sprite_2d: Sprite2D

var canFire = false
var target : CharacterBody2D

var d := 0.0
var radius := 150.0
var speed := 2.0
var sprite_rotation : float

var min_rot = deg_to_rad(-180.0)
var max_rot = deg_to_rad(0.0)

func setup() -> void :
	for c in get_children():
		if c is Sprite2D and not sprite_2d:
			sprite_2d = c

#Save starting rotation
func _ready() -> void :
	setup()
	if sprite_2d:
		sprite_2d.rotation = 0
		sprite_rotation = 0
		timer.timeout.connect( print_abc )
	
#func rotate() -> void :
	#gun_sprite.rotation = clampf(gun_sprite.rotation, min_rot, max_rot)
	#d += delta
	#position = Vector2( sin(d * speed) * radius, cos(d * speed) * radius ) + get_global_mouse_position()
	#pass

func print_abc() -> void :
	print( "abc" )
	
func _process(delta: float) -> void:
	
	pass
		
		#gun_sprite.look_at(  target.global_position )
		
		#if Input.is_action_just_pressed("fire"):
			#var projectile_instance = BULLET_SCENE.instantiate()
			#get_tree().root.add_child(projectile_instance)
			#projectile_instance.global_position = global_position 
			#projectile_instance.global_rotation = global_rotation
			
# This method is only called by Player.gd.
func shoot(direction: float = 1.0) -> bool:
	if firing_mode == FiringMode.GRUNT :
			#
		#if not timer.is_stopped():
			#return false
		var bullet := BULLET_SCENE.instantiate() as EnemyBullet
		bullet.global_position = global_position
		bullet.dir = direction
		#bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)

		bullet.set_as_top_level(true)
		add_child(bullet)
		##sound_shoot.play()
		#timer.start()
	elif firing_mode == FiringMode.TANK and sprite_2d:
		pass
		#var start : float = .6 * direction
		#var end : float = .6 * -direction
		#var temp : float
		#if start < end :
			#temp = start
			#while start < end : 
				#var bullet := BULLET_SCENE.instantiate() as EnemyBullet
				#bullet.global_position = global_position
				##bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)
#
				#bullet.set_as_top_level(true)
				#add_child(bullet)
				#start += .3
			#end = temp
			#while start > end :
				#var bullet := BULLET_SCENE.instantiate() as EnemyBullet
				#bullet.global_position = global_position
				##bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)
#
				#bullet.set_as_top_level(true)
				#add_child(bullet)
				#start -= .3
		#elif start > end :
			#temp = start
			#while start > end :
				#var bullet := BULLET_SCENE.instantiate() as EnemyBullet
				#bullet.global_position = global_position
				##bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)
#
				#bullet.set_as_top_level(true)
				#add_child(bullet)
				#start -= .3
			#end = temp
			#while start < end :
				#var bullet := BULLET_SCENE.instantiate() as EnemyBullet
				#bullet.global_position = global_position
				##bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)
#
				#bullet.set_as_top_level(true)
				#add_child(bullet)
				#start += .3
		#direction -= .33
	return true
#
func flip( new_dir : float ):
	
	#if direction_x > 0:
	#	scale.x *= 1
	#elif direction_x < 0:
	#	scale.x *= -1
	if sprite_2d :
		if new_dir < 0 : sprite_2d.flip_h = true
		if new_dir > 0 : sprite_2d.flip_h = false
	# changed from the prior version so we can flip it as a child of whatever its parent is
	# this way it'll work closer to have a hitbox would be flipped upon changing sides in a fighting game
	if new_dir < 0 and position.x > 0 or new_dir > 0 and position.x < 0 :
		position.x *= -1
