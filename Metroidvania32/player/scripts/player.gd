class_name Player extends CharacterBody2D

#region /// export variables (used to expose variable to inspector)
@export var move_speed : float = 250.0
#endregion

const SPEED = 150.0
const DASH_SPEED = 600.0
const DASH_DURATION = 0.2
const ATTACK_DURATION = 0.3

# Player Stats
var HEALTH = 100.0

# Status Flags
var can_attack = true
var is_attacking = false
var is_climbing = false
var is_interacting = false # for handling dialogue or object interaction

#region /// State Machine Variables
var states : Array[ PlayerState ]
var current_state : PlayerState : 
	get : return states.front()
var previous_state : PlayerState :
	get : return states[ 1 ]
#endregion

#region /// Standard Variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var base_move_speed : int = 100
var rotation_speed : float = 10.0
#endregion 

#@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	#initialize states
	initalize_states()
	pass

func _unhandled_input( event: InputEvent ) -> void:
	change_state( current_state.handle_input( event ))
	pass

func _process( _delta: float) -> void:
	update_direction()
	change_state( current_state.process( _delta ) )
	pass
	
func _physics_process( _delta: float ) -> void:
	velocity.y += gravity * _delta
	move_and_slide()
	change_state( current_state.physics_process( _delta ) )
	pass 

func initalize_states() -> void:
	states = []
	# Gather all states
	for c in $States.get_children():
		if c is PlayerState:
			states.append( c )
			c.player = self
		pass
	
	if states.size() == 0:
		return
	
	# initialize all states
	for state in states:
		state.init()
	# set our first state	
	
	change_state( current_state )
	current_state.enter()
	$Label.text = current_state.name
	
	pass
	
	
func change_state( new_state : PlayerState ) -> void:
	if new_state == null:
		return  
	elif new_state == current_state:
		return
		
	if current_state:
		current_state.exit()
		
	states.push_front( new_state )
	current_state.enter()
	states.resize( 3 ) # increase as needed
	$Label.text = current_state.name
	
	pass
	
func update_direction():
	#var prev_direction : Vector2 = direction 
	# negative x is left, positive x is right, negative y is up, positive y is down
	# calculating axis to help avoid deadzone/stick drift issues for gamepads
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	#$Label.text = str(direction)
	pass
	
func add_debug_indicator() -> void:
	#var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	#get_tree().root.add_child( d )
	#d.global_position = global_position
	pass
	
