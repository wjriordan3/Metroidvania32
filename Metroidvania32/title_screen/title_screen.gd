extends CanvasLayer

#region /// on ready variables
@onready var main_menu: VBoxContainer = %MainMenu
@onready var new_game_menu: VBoxContainer = %NewGameMenu
@onready var load_game_menu: VBoxContainer = %LoadGameMenu

@onready var new_game_button: Button = %NewGameButton
@onready var load_game_button: Button = %LoadGameButton
@onready var quit_game_button: Button = %QuitGameButton

@onready var new_slot_01: Button = %NewSlot01
@onready var new_slot_02: Button = %NewSlot02
@onready var new_slot_03: Button = %NewSlot03

@onready var load_slot_01: Button = %LoadSlot01
@onready var load_slot_02: Button = %LoadSlot02
@onready var load_slot_03: Button = %LoadSlot03
#endregion

func _ready() -> void:
	# connect to button signals
	new_game_button.pressed.connect( show_new_game_menu ) 
	load_game_button.pressed.connect( show_load_game_menu ) 
	quit_game_button.pressed.connect( _on_quit_game_pressed )
	
	new_slot_01.pressed.connect( _on_new_game_pressed.bind( 0 ) )
	new_slot_02.pressed.connect( _on_new_game_pressed.bind( 1 ) )
	new_slot_03.pressed.connect( _on_new_game_pressed.bind( 2 ) )
	
	load_slot_01.pressed.connect( _on_load_game_pressed.bind( 0 ) )
	load_slot_02.pressed.connect( _on_load_game_pressed.bind( 1 ) )
	load_slot_03.pressed.connect( _on_load_game_pressed.bind( 2 ) )
	
	# add audio to buttons
	Audio.setup_button_audio( self )
	Audio.play_music( preload("uid://7vg4nkki40en") )
	# show main menu
	show_main_menu()
	# setup anim transitions
	pass
	
func _unhandled_input( event: InputEvent ) -> void:
	if event.is_action_pressed("ui_cancel"):
		if main_menu.visible == false:
			# Audio
			show_main_menu()
	
func show_new_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = true
	load_game_menu.visible = false
	
	new_slot_01.grab_focus()
	
	if SaveManager.save_file_exists( 0 ):
		new_slot_01.text = "Overwrite Slot 01"
		
	if SaveManager.save_file_exists( 1 ):
		new_slot_02.text = "Overwrite Slot 02"
		
	if SaveManager.save_file_exists( 2 ):
		new_slot_03.text = "Overwrite Slot 03"
	
	pass
	
func show_load_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = false
	load_game_menu.visible = true
	
	load_slot_01.grab_focus()
	
	# cursed...don't know why this uses .disabled instead of an .enabled...
	load_slot_01.disabled = SaveManager.save_file_exists( 0 )
	load_slot_02.disabled = SaveManager.save_file_exists( 1 )
	load_slot_03.disabled = SaveManager.save_file_exists( 2 )
	
	pass

func _on_new_game_pressed( slot : int ) -> void:
	SaveManager.create_new_game_save( slot )
	pass

func _on_load_game_pressed( slot : int ) -> void:
	SaveManager.load_game( slot )
	
func _on_quit_game_pressed() -> void:
	get_tree().quit()

func show_main_menu() -> void:
	main_menu.visible = true
	new_game_menu.visible = false
	load_game_menu.visible = false
	# focus new game button
	new_game_button.grab_focus()
	
	pass
