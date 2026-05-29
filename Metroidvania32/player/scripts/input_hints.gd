@icon("res://addons/input_prompts/joypad_button_prompt/icon.svg")
class_name InputHints extends Node2D



const HINT_MAP : Dictionary = {
	"keyboard" : {
		"interact" : "res://addons/input_prompts/icons/keyboard/f.png",
		"attack" : "res://addons/input_prompts/icons/keyboard/j.png",
		"jump" : "res://addons/input_prompts/icons/keyboard/space.png",
		"up" : "res://addons/input_prompts/icons/keyboard/w.png",
		"down" : "res://addons/input_prompts/icons/keyboard/s.png"
	},
	"xbox" : {
		"interact" : "res://addons/input_prompts/icons/xbox/y.png",
		"attack" : "res://addons/input_prompts/icons/xbox/x.png",
		"jump" : "res://addons/input_prompts/icons/xbox/a.png",
		"up" : "res://addons/input_prompts/icons/generic/left_stick_up.png",
		"down" : "res://addons/input_prompts/icons/generic/left_stick_down.png"
	},
	"playstation" : {
		"interact" : "res://addons/input_prompts/icons/sony/triangle.png",
		"attack" : "res://addons/input_prompts/icons/sony/square.png",
		"jump" : "res://addons/input_prompts/icons/sony/cross.png",
		"up" : "res://addons/input_prompts/icons/generic/left_stick_up.png",
		"down" : "res://addons/input_prompts/icons/generic/left_stick_down.png"
	},
	"nintendo" : {
		"interact" : "res://addons/input_prompts/icons/nintendo/x.png",
		"attack" : "res://addons/input_prompts/icons/nintendo/y.png",
		"jump" : "res://addons/input_prompts/icons/nintendo/b.png",
		"up" : "res://addons/input_prompts/icons/generic/left_stick_up.png",
		"down" : "res://addons/input_prompts/icons/generic/left_stick_down.png"
	},
}

var controller_type : String = "keyboard"

enum Icons {
	AUTOMATIC,
	XBOX,
	SONY,
	NINTENDO,
	KEYBOARD,
}

#@export var ControlType : Icons = Icons.AUTOMATIC :
#	set( value ):
#		ControlType = value

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	visible = false
	Messages.input_hint_changed.connect( _on_hint_changed )
	pass
	
func _input( event: InputEvent ) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		controller_type = "keyboard"
	elif event is InputEventJoypadButton:
		get_controller_type( event.device )
	pass

func get_controller_type( device_id : int ) -> void:
	var n : String = Input.get_joy_name( device_id ).to_lower()
	
	if "xbox" in n:
		controller_type = "xbox"
	elif "playstation" in n or "ps" in n or "dualsense" in n:
		controller_type = "playstation"
	elif "nintendo" in n or "switch" in n:
		controller_type = "nintendo"
	else:
		controller_type = "unknown"
	
	print(controller_type)
	set_process_input( false )
	pass	

func _on_hint_changed( hint : String ) -> void:
	if hint == "":
		visible = false
	else:
		visible = true
		# Update sprite icon
		sprite_2d.texture = load(
			HINT_MAP.get(controller_type, HINT_MAP["xbox"]).get(hint, "res://addons/input_prompts/icons/keyboard/f.png")
		)
	pass
