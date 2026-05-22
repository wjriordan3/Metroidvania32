class_name ScrapCounterExample extends Panel

var _scrap_collected: int = 0

@onready var _scrap_label := $Label

func _ready() -> void:
	_scrap_label.set_text(str(_scrap_collected))
	visible = false # Hiding scrap UI on game start

func collect_scrap() -> void:
	_scrap_collected += 1
	_scrap_label.set_text(str(_scrap_collected))
