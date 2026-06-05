# PooledBullet.gd
extends CharacterBody2D

const SPEED = 800.0

var direction: Vector2 = Vector2.RIGHT
var pool_manager: Node 
var scene_path: String # Holds own scene path

# VisibleonScreenNotifier2D node for off-screen detection
@onready var screen_notifier = $VisibleOnScreenNotifier2D
@onready var attack_area : AttackArea = $AttackArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get own scene path (scene_file_path available at _ready() time)
	if scene_file_path:
		scene_path = scene_file_path
	else:
		printerr("Could not determine scene file path for pooling.")
	# Connect signal to return self to pool when going off-screen
	screen_notifier.screen_exited.connect(return_to_pool)
	#Activate attack area (hard set)
	attack_area.set_active( true )

# Method to set reference to pool manager
func set_pool_manager(manager: Node):
	pool_manager = manager   
	
# Initialization method to replace _ready()
func spawn(start_position: Vector2, travel_direction: Vector2):
	global_position = start_position
	direction = travel_direction.normalized()
	rotation = direction.angle()
	
# Method to reset state
func reset():
	# Reset physical state
	velocity = Vector2.ZERO
	# Reset other custom variables to inital values
	# (example: damage = 10)
	
func _physics_process(_delta):
	velocity = direction * SPEED
	move_and_slide()
	
# Function called on collision (example)
func _on_body_entered(_body):
	# Here you might spawn hit effect from pool, etc.
	# var hit_effect = pool_manager.get_object("res://effects/hit_effect.tscn")
	# hit_effect.global_position = global_position
	return_to_pool()
	
# Return self to pool
func return_to_pool():
	if pool_manager and scene_path:
		# Safely return with deferred call
		pool_manager.call_deferred("return_object", self, scene_path)
		#Deactivate attack area (hard set)
		attack_area.set_active( false )
	else:
		# Normal destruction if no pool
		queue_free()
