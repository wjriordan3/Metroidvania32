class_name AbilityStateMachine
extends Node

var current_state : AbilityState
@onready var none_state: AbilityStateNone = $None
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is AbilityState:
			child.mecha = get_parent()
			child.state_machine = self
			child.init()
			
	change_state(none_state)

func add_state(state : AbilityState):
	states[state.name] = state
	state.mecha = get_parent()
	add_child(state)
	state.init()

func change_state(new_state : AbilityState):
	if new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
		
	current_state = new_state
	
	if current_state:
		current_state.enter()
		
func change_state_by_name(state_name : String):
	if states.has(state_name):
		change_state(states[state_name])
		
func clear_states():
	for child in get_children():
		if child is AbilityState:
			child.queue_free()
	
	states.clear()
	current_state = null
		
func _physics_process(delta: float) -> void:
	if current_state == null:
		return
		
	var next_state = current_state.physics_process(delta)
	
	if next_state:
		change_state(next_state)
