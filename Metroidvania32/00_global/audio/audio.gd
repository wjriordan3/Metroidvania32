# Audio global script do NOT assign class_name
extends Node

enum REVERB_TYPE { NONE, SMALL, MEDIUM, LARGE }

@export var ui_focus_audio : AudioStream
@export var ui_select_audio : AudioStream
@export var ui_cancel_audio : AudioStream
@export var ui_success_audio : AudioStream
@export var ui_error_audio : AudioStream

var current_track : int = 0
var music_tweens : Array[ Tween ]
var ui_audio_player : AudioStreamPlaybackPolyphonic

@onready var music_1: AudioStreamPlayer = %Music1
@onready var music_2: AudioStreamPlayer = %Music2
@onready var ui: AudioStreamPlayer = %UI

func _ready() -> void:
	ui.play()
	ui_audio_player = ui.get_stream_playback()	
	pass
	
func play_music( audio : AudioStream ) -> void:
	music_1.stream = audio
	music_1.play()
	pass
	
func play_ui_audio( audio : AudioStream ) -> void:
	if ui_audio_player:
		ui_audio_player.play_stream( audio )
	pass

# Searches for buttons in node and adds audio to press and focus events
func setup_button_audio( node : Node ) -> void:
	for c in node.find_children( "*", "Button" ):
		c.pressed.connect( ui_select )
		c.focus_entered.connect( ui_focus_change )
		pass
	pass
	
#region // UI Functions

func ui_focus_change() -> void:
	play_ui_audio( ui_focus_audio )
	pass
	
func ui_select() -> void:
	play_ui_audio( ui_focus_audio )
	pass
	
func ui_cancel() -> void:
	play_ui_audio( ui_cancel_audio )
	pass

func ui_success() -> void:
	play_ui_audio( ui_success_audio )
	pass	

func ui_error() -> void:
	play_ui_audio( ui_error_audio )
	pass
	
#endregion
