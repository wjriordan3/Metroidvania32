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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
