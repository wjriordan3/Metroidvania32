@icon( "res://general/icons/save_point.svg" )
class_name SavePoint extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer
@onready var label: Label = $Node2D/Label
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var HealPlayerOnInteract: bool = true

func _ready() -> void:
	label.visible = false
	area_2d.body_entered.connect( _on_player_entered )
	area_2d.body_exited.connect( _on_player_exited )
	pass
	
func _on_player_entered( _n : Node2D ) -> void:
	if not _n.is_in_group("player"):
		return
		
	print("Player entered")
	Messages.player_interacted.connect( _on_player_interacted )
	Messages.input_hint_changed.emit( "interact" )
	sprite_2d.play("open_door")
	await sprite_2d.animation_finished
	sprite_2d.play("idle")
	pass

func _on_player_exited( _n : Node2D ) -> void:
	if not _n.is_in_group("player"):
		return
		
	print("Player exited")
	Messages.player_interacted.disconnect( _on_player_interacted )
	Messages.input_hint_changed.emit( "" )
	sprite_2d.play("close_door")
	await sprite_2d.animation_finished
	sprite_2d.play("door_closed")
	pass

func _on_player_interacted( player : Player ) -> void:
	print("Player interacted")
	# Heal player?
	if HealPlayerOnInteract:
		player.stats.heal( 999 )
	# Save game
	SaveManager.save_game()
	# Animation
	animation_player.play("game_saved")
	animation_player.seek( 0 ) # return animation back to first frame
	# Audio
	Audio.ui_success()
	pass
