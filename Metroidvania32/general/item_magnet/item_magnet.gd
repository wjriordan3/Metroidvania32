class_name ItemMagnet extends Area2D

var items : Array[ItemPickup] = []
var speeds : Array[float] = []

@export var magnet_strength : float = 1.0

func _ready() -> void:
	area_entered.connect( _on_area_enter )
	pass
	
func _on_area_enter( _a : Area2D ) -> void:
	
	pass
