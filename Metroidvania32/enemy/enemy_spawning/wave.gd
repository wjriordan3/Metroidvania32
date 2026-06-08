class_name Wave extends Resource

@export var groups: Array[SpawnGroup]

@export var wait_until_cleared := true

@export_range(0.0, 30.0, 0.1)
var delay_after_wave: float = 0.0
