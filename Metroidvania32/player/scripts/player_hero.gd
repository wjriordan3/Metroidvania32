class_name PlayerHero extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://c71luhhdj6x5x")

#region /// onready variables
@onready var hero_sprite: AnimatedSprite2D = $HeroSprite
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var one_way_platform_shapecast: ShapeCast2D = $OneWayPlatformShapecast
#endregion


#region /// export variables (used to expose variable to inspector)
@export var move_speed : float = 250.0
@export var max_fall_velocity : float = 600.0

#endregion

const SPEED = 150.0
const DASH_SPEED = 600.0
const DASH_DURATION = 0.2
const ATTACK_DURATION = 0.3

# Status Flags
var activePlayer = true
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

#region /// Player Stats
@onready var health: HealthComponent = $Health
var double_jump : bool = false
#endregion

#region /// Standard Variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_multiplier : float = 1.0
var crouch_multiplier : float = 1.0
var base_move_speed : int = 100
var rotation_speed : float = 10.0
#endregion 

func _ready() -> void:
	#if get_tree().get_first_node_in_group("player") != self:
	#	self.queue_free()
	
	add_to_group("player")
	#initialize states
	initalize_states()
	#self.call_deferred("reparent", get_tree().root)
	CameraManager.set_target(self)
	#check_for_camera()
	pass

func _unhandled_input( event: InputEvent ) -> void:
	change_state( current_state.handle_input( event ))
	pass

func _process( _delta: float) -> void:
	if not activePlayer: return
	update_direction()
	change_state( current_state.process( _delta ) )
	pass
	
func _physics_process( _delta: float ) -> void:
	if not activePlayer: return
	velocity.y += gravity * _delta * gravity_multiplier
	velocity.y = clampf(velocity.y, -10000, max_fall_velocity)
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
	var prev_direction : Vector2 = direction 
	# negative x is left, positive x is right, negative y is up, positive y is down
	# calculating axis to help avoid deadzone/stick drift issues for gamepads
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	#$Label.text = str(direction)
	
	if prev_direction.x != direction.x:
		if direction.x < 0: # character facing left
			hero_sprite.flip_h = true
		if direction.x > 0: # character facing right
			hero_sprite.flip_h = false
	pass

func add_debug_indicator( color : Color = Color.RED ) -> void:
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child( d )
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 3.0 ).timeout
	d.queue_free()
	pass
	
func check_for_camera() -> void:
	if !get_tree().get_first_node_in_group("main_camera"):
		var scene = preload("res://general/camera_2d.tscn")
		var camera = scene.instantiate()
		
		get_tree().current_scene.call_deferred("add_child", camera)
		
func _exit_tree():
	CameraManager.clear_target(self)
	
#region Items and Inventory
func will_pickup(item):
	$Inventory.pickup(item)
func get_item(itemData):
	$Inventory.get_item(itemData)
#endregion
