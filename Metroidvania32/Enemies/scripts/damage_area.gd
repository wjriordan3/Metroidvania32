class_name DamageArea extends Area2D

signal damage_taken( attack_area )

@export var audio : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func take_damage( area : Area2D ) -> void:
	if area is AttackArea:
		damage_taken.emit( area )
		print( "Attack damage taken", area.damage )
	elif area is HazardArea:
		damage_taken.emit( area )
		print( "Hazard damage taken", area.damage )
	if audio:
		Audio.play_spatial_sound ( audio, global_position )
	pass
	

func make_invulnerable(duration : float = 1.0 ) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer( duration ).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
