extends Area2D
@onready var level_bounds = $LevelBounds

# Pause game and start dialogue when player enters area
func _on_body_entered(body: Node2D) -> void:
	
	
	level_bounds.x += 1920
	print("level bounds should move")
