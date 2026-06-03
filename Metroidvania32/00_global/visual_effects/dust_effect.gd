class_name DustEffect extends AnimatedSprite2D

enum TYPE { HIT, JUMP, LAND }

func start( type: TYPE ) -> void:
	var anim_name : String = "jump"
	match type:
		TYPE.JUMP:
			position.y -= 14
		TYPE.LAND:
			anim_name = "land"
			position.y -= 14
		TYPE.HIT:
			anim_name = "hit"
			rotation_degrees = randi_range( 0, 3 ) * 90
	play(anim_name)
	await animation_finished
	queue_free()
	pass
