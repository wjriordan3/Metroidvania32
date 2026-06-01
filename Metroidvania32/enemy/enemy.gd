class_name Enemy extends CharacterBody2D


@export var health : float = 3
@export var move_speed : float = 30
@export var face_left_on_start : bool = true
@export var death_sound : AudioStream

var dir : float = 1.0
var move_tween : Tween

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var damage_area : DamageArea = $DamageArea
@onready var attack_area : AttackArea = $AttackArea
@onready var edge_detector : EdgeDetector = $EdgeDetector


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#animation_player.play("walk")
	edge_detector.edge_detected.connect( _on_edge_detected )
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_on_wall():
		change_direction( -dir ) 
	velocity += get_gravity() * delta
	velocity.x = dir * move_speed
	move_and_slide()
	pass

func change_direction( new_dir : float ) -> void:
	dir = new_dir
	edge_detector.direction_changed( dir )
	if dir < 0 :
		sprite.flip_h = true
	elif dir > 0 :
		sprite.flip_h = false
	
	pass

func _on_edge_detected() -> void:
	if is_on_floor():
		change_direction( -dir )
	pass
