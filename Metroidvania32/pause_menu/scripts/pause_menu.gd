extends CanvasLayer

#region /// Signals
signal pause_screen_shown
signal pause_screen_hidden
#endregion

#region /// On ready variables
@onready var pause_screen: Control = %PauseScreen
@onready var system: Control = %System
@onready var gear: Control = %Gear
@onready var map: Control = %MapUi
@onready var vitals: Control = %Vitals

# Menu Navigation Tabs
@onready var system_nav_button: Button = %SystemNavButton
@onready var gear_nav_button: Button = %GearNavButton
@onready var map_nav_button: Button = %MapNavButton

@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_game_button: Button = %QuitGameButton

@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider

@onready var item_description: Label = $Control/PauseScreen/Gear/ItemDescription
#endregion


var player : Player = null
var is_paused = false

func _ready() -> void:
	hide_pause_screen()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	setup_system_menu()
	
	system_nav_button.pressed.connect( show_system_menu )
	gear_nav_button.pressed.connect( show_gear_menu )
	map_nav_button.pressed.connect( show_map_menu )
	
	# audio setup
	Audio.setup_button_audio( self )
	
	# setup system
	show_vitals_menu()
	
			
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "pause" ):
		if is_paused == false:
			show_pause_screen()
		else:
			hide_pause_screen()
		get_viewport().set_input_as_handled()
		
	if pause_screen.visible == true:
		if event.is_action_pressed("right") or event.is_action_pressed("down"):
			system_nav_button.grab_focus()
	
	pass
	
func _on_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	
func show_pause_screen() -> void:
	visible = true
	pause_screen.visible = true
	vitals.visible = false
	gear.visible = false
	map.visible = false
	system.visible = false
	
	is_paused = true
	get_tree().paused = true
	
	pause_screen_shown.emit()
	
func hide_pause_screen() -> void:
	
	is_paused = false
	get_tree().paused = false
	pause_screen.visible = false
	visible = false
	pause_screen_hidden.emit()
	
func show_map_menu() -> void:
	vitals.visible = false
	gear.visible = false
	system.visible = false
	map.visible = true
	
func show_system_menu() -> void:
	vitals.visible = false
	gear.visible = false
	map.visible = false
	system.visible = true
	
func show_gear_menu() -> void:
	vitals.visible = false
	system.visible = false
	gear.visible = true
	map.visible = false
	
func show_vitals_menu() -> void:
	vitals.visible = true
	system.visible = false
	gear.visible = false
	map.visible = false

func setup_system_menu() -> void:
	main_menu_button.pressed.connect( _on_main_menu_button_pressed )
	quit_game_button.pressed.connect( _on_quit_game_button_pressed )
	
	# setup the sliders
	music_slider.value = AudioServer.get_bus_volume_linear( 2 )
	sfx_slider.value = AudioServer.get_bus_volume_linear( 3 ) 
	ui_slider.value = AudioServer.get_bus_volume_linear( 4 )
	
	music_slider.value_changed.connect( _on_music_slider_changed )
	sfx_slider.value_changed.connect( _on_sfx_slider_changed )
	ui_slider.value_changed.connect( _on_ui_slider_changed )
	
	pass
	
func _on_main_menu_button_pressed() -> void:
	SceneManager.transition_scene("res://title_screen/title_screen.tscn", "", Vector2.ZERO, "up")
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()
	
func _on_quit_game_button_pressed() -> void:
	get_tree().quit()

func focused_item_changed( slot : SlotData ) -> void:
	if slot:
		if slot.item_data:
			update_item_description( slot.item_data.description )
			# update stats
	else:
		update_item_description("")
		# update stats
		
func _on_music_slider_changed( v : float ) -> void:
	AudioServer.set_bus_volume_linear( 2, v )
	# save to settings
	Config.save_configuration()
	pass
	
func _on_sfx_slider_changed( v : float ) -> void:
	AudioServer.set_bus_volume_linear( 3, v )
	Audio.play_spatial_sound( Audio.ui_select_audio, PlayerManager.player.global_position)
	# save to settings
	Config.save_configuration()
	pass
	
func _on_ui_slider_changed( v : float ) -> void:
	AudioServer.set_bus_volume_linear( 4, v )
	Audio.ui_focus_change()
	# save to settings
	Config.save_configuration()
	pass
	
func update_item_description( new_text : String ) -> void:
	item_description.text = new_text
	pass
