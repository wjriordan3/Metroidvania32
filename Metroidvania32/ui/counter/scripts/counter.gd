class_name Counter extends Panel

var _counter_value: int = 0

@onready var _counter_label := $Label

func _ready() -> void:
	_counter_label.set_text(str(_counter_value))

func update_counter(value: int) -> void:
	_counter_value = value
	_counter_label.set_text(str(_counter_value))
