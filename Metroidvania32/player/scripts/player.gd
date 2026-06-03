class_name Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://c71luhhdj6x5x")

#region /// Signals
signal damage_taken
#endregion

#region /// onready variables
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var da_stand: CollisionShape2D = $DamageArea/DAStand
@onready var da_crouch: CollisionShape2D = $DamageArea/DACrouch
@onready var one_way_platform_shapecast: ShapeCast2D = $OneWayPlatformShapecast
@onready var shoot_timer := $ShootAnimation as Timer
@onready var gun: Node2D = $Gun
@onready var damage_area: DamageArea = %DamageArea
@onready var ceiling_ray_cast_2d: RayCast2D = $CeilingRayCast2D

#endregion

#region /// export variables (used to expose variable to inspector)
@export var stats : Stats
#endregion

var current_mech: MechaUnit = null
var current_interactable = null
var pilot_tag := "player"

# Status Flags
var activePlayer = true
var can_attack = true
var is_attacking = false
var is_shooting = false
var is_climbing = false
var is_interacting = false # for handling dialogue or object interaction

#region /// State Machine Variables
var states : Array[ PlayerState ]
var current_state : PlayerState : 
	get : return states.front()
var previous_state : PlayerState :
	get : return states[ 1 ]
#endregion

#region /// Ability Flags
var double_jump : bool = false
#endregion

#region /// Standard Variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_multiplier : float = 1.0
var crouch_multiplier : float = 1.0
var rotation_speed : float = 10.0
#endregion 

func _ready() -> void:
	add_to_group("player")
	initalize_states()
	Messages.back_to_title_screen.connect(queue_free)
	damage_area.damage_taken.connect( _on_damage_taken )
	CameraManager.set_target(self)
	stats.health = stats.current_max_health
	pass

func _unhandled_input( event: InputEvent ) -> void:
	if event.is_action_pressed( "action" ):
		Messages.player_interacted.emit( self )
	#elif event.is_action_pressed( "pause" ):
	#	get_tree().paused = true # will pause any node with process set to inherit
	#	var pause_menu : PauseMenu = load( "res://pause_menu/pause_menu.tscn" ).instantiate()
	#	add_child( pause_menu )
	#	return
		
	# For testing health, remove later
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_MINUS:
			if Input.is_key_pressed( KEY_SHIFT ):
				stats.take_damage(10)
				print(stats.health)
				Messages.player_health_changed.emit(stats.health, stats.current_max_health)
			else:
				stats.take_damage(2)
				print(stats.health)
				Messages.player_health_changed.emit(stats.health, stats.current_max_health)
		elif event.keycode == KEY_EQUAL:
			if Input.is_key_pressed( KEY_SHIFT ):
				stats.current_max_health += 10
				print(stats.current_max_health)
				Messages.player_health_changed.emit(stats.health, stats.current_max_health)
			else:
				stats.health += 2
				print(stats.health)
				Messages.player_health_changed.emit(stats.health, stats.current_max_health)
	# end for remove code later
	
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
	velocity.y = clampf(velocity.y, -10000, stats.max_fall_velocity)
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
	
func is_in_mech() -> bool:
	return current_mech != null	

func is_climb_ceiling():
	return ceiling_ray_cast_2d.is_colliding()
	
func release_climb_ceiling():
	ceiling_ray_cast_2d.enabled = false

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
			sprite.flip_h = true
			
		if direction.x > 0: # character facing right
			sprite.flip_h = false
			
	pass

func add_debug_indicator( color : Color = Color.RED ) -> void:
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child( d )
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 3.0 ).timeout
	d.queue_free()
	pass

		
func _exit_tree():
	CameraManager.clear_target(self)
	
#region Items and Inventory
#func will_pickup(item):
#	$Inventory.pickup(item)
#func get_item(itemData):
#	$Inventory.get_item(itemData)
#endregion

func _on_damage_taken( attack_area : AttackArea ) -> void:
	if current_state == current_state.death:
		return
	stats.take_damage(attack_area.damage)
	damage_taken.emit()
	print("Player took damage: ", stats.health)
	pass
