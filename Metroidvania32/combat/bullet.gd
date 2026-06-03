class_name Bullet extends Area2D

var FPS = Engine.get_frames_per_second()
var direction = 1;
#var speed_dir = Vector2(0, 0)
var speed = 10
var time = 1

func _ready():
	if FPS == 60:
		speed /= 2
		time *= 2
	if direction == 2:
		self.rotation_degrees = 90
	elif direction == 3:
		self.rotation_degrees = 90
		
var delete_this = false
var enemy_hit = false

func _physics_process(_delta):
	position += transform.x * speed * time
	for enemy in self.get_overlapping_bodies():
		if not delete_this:
			pass
