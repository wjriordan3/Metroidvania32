class_name AbilityState extends Node

var mecha : MechaUnit
var state_machine : AbilityStateMachine
var next_state : AbilityState

# What occurs when the state is initialized?
func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> AbilityState:
	return next_state
	
func process( _delta: float) -> AbilityState:
	return next_state 
	
func physics_process( _delta: float) -> AbilityState:
	return next_state 
	
