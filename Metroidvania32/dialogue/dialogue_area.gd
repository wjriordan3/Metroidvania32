extends Area2D

@export var timeline: String
@export var repeatable = false
@export var retrigger_delay = 0.5

# Track whether dialog has been triggered
var triggered = false

func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

# Pause game and start dialogue when player enters area
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not triggered:
		triggered = true
		Dialogic.start(timeline)

# Post-dialogue logic
func _on_dialogic_timeline_ended():
	await get_tree().create_timer(retrigger_delay).timeout
	# Set trigger status based on repeatability
	triggered = !repeatable
