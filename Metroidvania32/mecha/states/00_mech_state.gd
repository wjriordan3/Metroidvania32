class_name MechaState extends Node

var mecha : MechaUnit
var next_state : MechaState

#region /// State References
# Contains references to all other states
@onready var idle: MechaStateIdle = %Idle
@onready var run: MechaStateRun = %Run
@onready var jump: MechaStateJump = %Jump
@onready var fall: MechaStateFall = %Fall
@onready var crouch: MechaStateCrouch = %Crouch
@onready var deactivate: MechaStateDeactivate = %Deactivate
#endregion

# What occurs when the state is initialized?
func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	pass
	
# What happens when we exit this state?
func exit() -> void:
	pass 
	
func handle_input( _event : InputEvent ) -> MechaState:
	return next_state
	
func process( _delta: float) -> MechaState:
	return next_state 
	
func physics_process( _delta: float) -> MechaState:
	return next_state 
	
