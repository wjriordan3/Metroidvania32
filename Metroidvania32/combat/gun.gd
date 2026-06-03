class_name Gun extends Marker2D

# Gun represents a weapon that spawns and shoots bullets
# The cooldown timer controls the cooldown duration between shots

const BULLET_VELOCITY = 850.0
const BULLET_SCENE = preload("res://combat/bullet.tscn")

@onready var gun_sprite: Sprite2D = $".."
@onready var sound_shoot := $Shoot as AudioStreamPlayer2D
@onready var timer := $Cooldown as Timer 

var canFire = false

func _process(_delta):
	if canFire:
		gun_sprite.look_at(get_global_mouse_position())
		
		if Input.is_action_just_pressed("fire"):
			var projectile_instance = BULLET_SCENE.instantiate()
			get_tree().root.add_child(projectile_instance)
			projectile_instance.global_position = global_position 
			projectile_instance.global_rotation = global_rotation
			
# This method is only called by Player.gd.
func shoot(direction: float = 1.0) -> bool:
	if not timer.is_stopped():
		return false
	var bullet := BULLET_SCENE.instantiate() as Bullet
	bullet.global_position = global_position
	#bullet.speed_dir = Vector2(direction * BULLET_VELOCITY, 0.0)

	bullet.set_as_top_level(true)
	add_child(bullet)
	#sound_shoot.play()
	timer.start()
	return true
