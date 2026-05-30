class_name PauseMenu extends CanvasLayer

#region /// On ready variables
@onready var pause_screen: Control = %PauseScreen
@onready var system: Control = %System
@onready var gear: Control = %Gear
@onready var map: Control = %Map

# Menu Navigation Tabs
@onready var system_nav_button: Button = %SystemNavButton
@onready var gear_nav_button: Button = %GearNavButton
@onready var map_nav_button: Button = %MapNavButton

@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_game_button: Button = %QuitGameButton

@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
#endregion

var player : Player

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# grab player
	show_pause_screen()
	setup_system_menu()
	system_nav_button.pressed.connect( show_system_menu )
	gear_nav_button.pressed.connect( show_gear_menu )
	map_nav_button.pressed.connect( show_map_menu )
	# show map
	# audio setup
	# setup system
	show_gear_menu()
			
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "pause" ):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
		
	if pause_screen.visible == true:
		if event.is_action_pressed("right") or event.is_action_pressed("down"):
			system_nav_button.grab_focus()
	
	pass
	
func _on_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	
func show_pause_screen() -> void:
	pause_screen.visible = true
	gear.visible = false
	map.visible = false
	system.visible = false
	
	get_tree().paused = true
	
func show_map_menu() -> void:
	gear.visible = false
	system.visible = false
	map.visible = true
	
func show_system_menu() -> void:
	gear.visible = false
	map.visible = false
	system.visible = true
	main_menu_button.grab_focus()
	
func show_gear_menu() -> void:
	system.visible = false
	gear.visible = true
	map.visible = false
	gear_nav_button.grab_focus()

func setup_system_menu() -> void:
	
	main_menu_button.pressed.connect( _on_main_menu_button_pressed )
	quit_game_button.pressed.connect( _on_quit_game_button_pressed )
	
	# setup the sliders
	pass
	
func _on_main_menu_button_pressed() -> void:
	SceneManager.transition_scene("res://title_screen/title_screen.tscn", "", Vector2.ZERO, "up")
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()
	
func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
