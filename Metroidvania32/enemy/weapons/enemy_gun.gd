class_name EnemyGun extends Marker2D

# Gun represents a weapon that spawns and shoots bullets
# The cooldown timer controls the cooldown duration between shots

const BULLET_VELOCITY = 850.0
const BULLET_SCENE = preload("res://enemy/weapons/enemy_bullet.tscn")

enum FiringMode { GRUNT, TANK, DRONE, BOSS }

@export var firing_mode : FiringMode

@onready var sound_shoot := $Shoot as AudioStreamPlayer2D
@onready var timer := $Timer as Timer 
@onready var pivot : Node2D = $Pivot

var canFire = false
var has_target : bool = false

var speed := .1
var sprite_rotation : float = deg_to_rad( 0 )
var gundir : float = -1

var min_rot = deg_to_rad(-180.0)
var max_rot = deg_to_rad(0.0)

var direction : float = 1


#Save starting rotation
func _ready() -> void :
	if firing_mode == FiringMode.TANK :
		timer.timeout.connect( rotate_and_shoot )

func shoot_once( direction : float = 1.0 ) -> void :
	var bullet := BULLET_SCENE.instantiate() as EnemyBullet
	bullet.global_position = global_position
	bullet.dir = direction
	#bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)

	bullet.set_as_top_level(true)
	add_child(bullet)
	
	
func rotate_and_shoot() -> void :
	var start : float = sprite_rotation
	sprite_rotation += (.2 * gundir)
	pivot.rotation = rotate_toward( start, sprite_rotation + (.2 * gundir), speed)
	
	if gundir < 0 :
		if sprite_rotation < min_rot :
			gundir = 1.0
	else :
		if sprite_rotation > max_rot :
			gundir = -1.0
			
	var bullet := BULLET_SCENE.instantiate() as EnemyBullet
	bullet.global_position = global_position
	bullet.rotation = sprite_rotation
	bullet.dir = 1
	#bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)

	bullet.set_as_top_level(true)
	add_child(bullet)
	
	if has_target :
		timer.start( .1 )
	else :
		timer.stop()
		sprite_rotation = deg_to_rad( 0 )
		pivot.rotation = sprite_rotation
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
		shoot_once( direction )
	elif firing_mode == FiringMode.TANK :
		timer.start(.1)
	
	return true
#
func flip( new_dir : float ):
	
	#if direction_x > 0:
	#	scale.x *= 1
	#elif direction_x < 0:
	#	scale.x *= -1
	# changed from the prior version so we can flip it as a child of whatever its parent is
	# this way it'll work closer to have a hitbox would be flipped upon changing sides in a fighting game
	if new_dir < 0 and position.x > 0 or new_dir > 0 and position.x < 0 :
		position.x *= -1
