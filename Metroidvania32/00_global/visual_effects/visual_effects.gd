# VisualEffects
# factory pattern for spawning visual effects for any entity that needs it
extends Node

const DUST_EFFECT = preload("uid://bu422nxeksqfu")

# Creates new instance of a dust effect
func _create_dust_effect( pos : Vector2 ) -> DustEffect:
	var dust : DustEffect = DUST_EFFECT.instantiate()
	add_child( dust )
	dust.global_position = pos  
	return dust

# create jump dust
func jump_dust( pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.JUMP )
	pass

# create land dust
func land_dust( pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.LAND )
	pass

# hit dust
func hit_dust( pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.HIT )
	pass
