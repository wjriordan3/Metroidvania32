@tool
extends Node2D

@onready var label: Label = $Label
@export_multiline var description : String:
	set(value):
		description = value
		_update_label()

func _ready() -> void:
	_update_label()

func _update_label():
	if label:
		label.text = description
		
