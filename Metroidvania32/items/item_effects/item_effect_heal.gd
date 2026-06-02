class_name ItemEffectHeal extends ItemEffect

@export var heal_amount : int = 1
@export var sound : AudioStream  

func use() -> void:
	PlayerManager.player.stats.heal(heal_amount)
	# play sound
