extends Node2D

@onready var timer: Timer = $Timer

@export var scene_to_spawn : PackedScene
@export var amount_to_spawn : int
@export var spawnInterval : float = 1.0

var spawn_counter : int

func _ready() -> void:
	timer.wait_time = spawnInterval
	spawn_counter = 0
	pass

func _on_timer_timeout() -> void:
	spawn_entity()
	
func spawn_entity():
	if spawn_counter >= amount_to_spawn:
		pass
	elif scene_to_spawn:
		var spawn_instance = scene_to_spawn.instantiate() 
		spawn_instance.position = position
		get_parent().add_child(spawn_instance)
		spawn_counter += 1
		print("Entity spawned: ", spawn_instance.name, " Total: ", spawn_counter)
	
