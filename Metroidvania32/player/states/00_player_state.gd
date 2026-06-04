@icon("res://player/states/state.svg")
class_name PlayerState extends Node

var player : Player
var next_state : PlayerState

#region /// State References
# Contains references to all other states
@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var hang: PlayerStateHang = %Hang
@onready var crouch: PlayerStateCrouch = %Crouch
@onready var attack: PlayerStateAttack = %Attack
@onready var hurt: PlayerStateHurt = %Hurt
@onready var death: PlayerStateDeath = %Death
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
	
func handle_input( _event : InputEvent ) -> PlayerState:
	return next_state
	
func process( _delta: float) -> PlayerState:
	return next_state 
	
func physics_process( _delta: float) -> PlayerState:
	return next_state 
	
