extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_area: DamageArea = $DamageArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_area.damage_taken.connect(_ouchie)
	animated_sprite_2d.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _ouchie(_area : Area2D) -> void:
	#print("Hit detected here: ", _area)
	animated_sprite_2d.play("hurt")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("idle")
	
