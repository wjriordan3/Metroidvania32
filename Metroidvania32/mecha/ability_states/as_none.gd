class_name AbilityStateNone extends AbilityState

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
# Won't trigger anything on input or need nextstate, limb parts will handle this
func handle_input( _event : InputEvent ) -> AbilityState:
	return null
	
func process( _delta: float) -> AbilityState:
	return null 
	
func physics_process( _delta: float) -> AbilityState:
	return null 
	
