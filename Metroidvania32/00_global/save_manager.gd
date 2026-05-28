# SaveManager script
extends Node

const SLOTS : Array[ String ] = [
	"save_01", "save_02", "save_03"
]

var current_slot : int = 0
var save_data : Dictionary
var discovered_areas : Array = []
var persistent_data : Dictionary = {}

const default_scene_uid : String = "uid://beln0e1ghjnm"

func _ready() -> void:
	pass
	
func _unhandled_key_input( event: InputEvent ) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_U:
			save_game()
		elif event.keycode == KEY_I:
			load_game()
		elif event.keycode == KEY_1:
			current_slot = 0
		elif event.keycode == KEY_2:
			current_slot = 1
		elif event.keycode == KEY_3:
			current_slot = 2
	pass
	
func create_new_game_save() -> void:
	var new_game_scene : String = default_scene_uid
	discovered_areas.append( new_game_scene )
	save_data = {
		"scene_path" : new_game_scene,
		"x" : 83,
		"y" : 285,
		"hp" : 100.0,
		"max_hp" : 100.0,
		# list out unlockable abilities here
		"double_jump" : false, 
		# -------------------
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
	}
	
	# Save Game Data
	var save_file = FileAccess.open( get_file_name(), FileAccess.WRITE )
	save_file.store_line( JSON.stringify( save_data ) )
	pass
	
func save_game() -> void:
	print("Saving the game...")
	var player : PlayerHero = get_tree().get_first_node_in_group( "player" )
	
	# Update Save Data
	save_data = {
		"scene_path" : SceneManager.current_scene_uid,
		"x" : player.global_position.x,
		"y" : player.global_position.y,
		"hp" : player.health.health,
		"max_hp" : player.health.max_health,
		# list out unlockable abilities here
		"double_jump" : player.double_jump, 
		# -------------------
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
	}
	# Save Game Data
	var save_file = FileAccess.open( get_file_name(), FileAccess.WRITE )
	save_file.store_line( JSON.stringify( save_data ) )
	pass
	
func load_game() -> void:
	print("Loading the game...")
	
	if FileAccess.file_exists( get_file_name() ):
		return
		
	var save_file = FileAccess.open( get_file_name(), FileAccess.READ )
	save_data = JSON.parse_string( save_file.get_line() )
	
	persistent_data = save_data.get( "persistent_data", {} )
	discovered_areas = save_data.get( "discovered_areas", [])
	var scene_path : String = save_data.get( "scene_path", default_scene_uid )
	SceneManager.transition_scene( scene_path, "", Vector2.ZERO, "up" )
	await SceneManager.new_scene_ready
	setup_player()
	pass
	
func setup_player() -> void:
	var player : PlayerHero = null
	while not player:
		get_tree().get_first_node_in_group( "player" )
		await get_tree().process_frame
	
	player.health.max_health = save_data.get( "max_hp", 100.0 )
	player.health.health = save_data.get( "hp", 100.0 )
	
	player.double_jump = save_data.get( "double_jump", false )
	
	player.global_position = Vector2(
		save_data.get( "x", 0 ),
		save_data.get( "y", 0 )
	)
	
	pass

func get_file_name() -> String:
	#"user://save.sav"
	return "user://" + SLOTS[ current_slot ] + ".sav"
