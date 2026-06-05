class_name AbilityStateDrill extends AbilityState

@export var duration : float = 0.5
@export var damage_per_second : float = 20.0

var timer : float = 0.0

func enter() -> void:
	timer = duration
	
	# add mech hooks below
	# mecha.set_drill_active(true)
	# mecha.play_animation("drill")
	
func exit() -> void:
	# mecha.set_drill_active(false)
	pass
	
func physics_process( delta: float) -> AbilityState:
	# start timer
	timer -= delta
	
	# continuous damage while active?
	mecha.deal_drill_damage(damage_per_second * delta)
	
	# transition back to none_state
	if timer <= 0.0:
		return state_machine.get_state("None")
		
	return null
