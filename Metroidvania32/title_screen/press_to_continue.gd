extends Node2D

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var title_screen: Control = $TitleScreen

var waiting_for_input: bool = false

func _ready() -> void:
	# Hide title screen on screen, play video
	title_screen.visible = false
	video_player.play()

func _on_video_stream_player_finished() -> void:
	# now that video is finished, show press any button screen
	video_player.visible = false
	title_screen.visible = true
	waiting_for_input = true 
	
func _input(event: InputEvent) -> void:
	# if video is finished and prompt is visible
	if not waiting_for_input:
		return
	
	# Check for any keyboard, joystick, or mouse input
	if event.is_released() and (event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton):
		waiting_for_input = true
		change_to_main_menu()
		
func change_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
