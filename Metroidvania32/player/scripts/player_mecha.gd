class_name PlayerMecha extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://c71luhhdj6x5x")

enum LimbSlot {
	CORE,
	LEFT_ARM,
	RIGHT_ARM,
	LEFT_LEG,
	RIGHT_LEG
}

var equipped_parts := {
	LimbSlot.CORE: null,
	LimbSlot.LEFT_ARM: null,
	LimbSlot.RIGHT_ARM: null,
	LimbSlot.LEFT_LEG: null,
	LimbSlot.RIGHT_LEG: null
}

#region /// onready variables
@onready var limb_sprites := {
	LimbSlot.CORE: $Core,
	LimbSlot.LEFT_ARM: $LeftArm,
	LimbSlot.RIGHT_ARM: $RightArm,
	LimbSlot.LEFT_LEG: $LeftLeg,
	LimbSlot.RIGHT_LEG: $RightLeg
}

@onready var core: AnimatedSprite2D = $Core
@onready var right_leg: AnimatedSprite2D = $RightLeg
@onready var left_leg: AnimatedSprite2D = $LeftLeg
@onready var left_arm: AnimatedSprite2D = $LeftArm
@onready var right_arm: AnimatedSprite2D = $RightArm

@onready var enter_hint_label: Label = $EntryLabel

@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var one_way_platform_shapecast: ShapeCast2D = $OneWayPlatformShapecast

@onready var idle_state: MechaStateIdle = %States/Idle
@onready var deactivate_state : MechaState = $States/Deactivate
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
var activePlayer = false
var can_attack = true
var is_attacking = false
var is_climbing = false
var is_interacting = false # for handling dialogue or object interaction

#region /// State Machine Variables
var states : Array[ MechaState ]
var current_state : MechaState : 
	get : return states.front()
var previous_state : MechaState :
	get : return states[ 1 ]
#endregion

#region /// Standard Variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_multiplier : float = 1.0
var crouch_multiplier : float = 1.0
var base_move_speed : int = 100
var rotation_speed : float = 10.0
#endregion 

#@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	#add_to_group("player")
	enter_hint_label.visible = false
	#initialize states
	initialize_states()
	pass

func _unhandled_input( event: InputEvent ) -> void:
	if not activePlayer: return
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

func initialize_states() -> void:
	states = []
	# Gather all states
	for c in $States.get_children():
		if c is MechaState:
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
	
	
func change_state( new_state : MechaState ) -> void:
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
			core.flip_h = true
			right_leg.flip_h = true
			left_leg.flip_h = true
			left_arm.flip_h = true
			right_arm.flip_h = true
		if direction.x > 0: # character facing right
			core.flip_h = false
			right_leg.flip_h = false
			left_leg.flip_h = false
			left_arm.flip_h = false
			right_arm.flip_h = false
	pass

func _input(event):
	if event.is_action_pressed("action") && event.is_pressed() && enter_hint_label.visible:
		_control_mech()
	elif activePlayer && event.is_action_pressed("action") && event.is_pressed() && self.is_on_floor(): # && current_state == MechaStateIdle
		_leave_mech()
		
func _control_mech():
	change_state(idle_state) # TODO: Change to activate state
	
	var player = get_tree().get_first_node_in_group("player")
	
	activePlayer = true
	player.queue_free()
	
	# Switch to mech camera
	CameraManager.set_target(self)
	CameraManager.set_zoom(Vector2(1.0, 1.0))
	
func _leave_mech():
	# Change state here
	change_state(deactivate_state)
	
	var player = preload("res://player/player_hero.tscn").instantiate()
	
	activePlayer = false
	get_tree().current_scene.add_child(player)
	player.global_position = global_position
	
	# Switch to main player camera
	CameraManager.set_target(player)
	CameraManager.set_zoom(Vector2(1.0, 1.0))
	
func _on_mech_area_collision_body_entered(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		enter_hint_label.show()

func _on_mech_area_collision_body_exited(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		enter_hint_label.hide()
	
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
	
#region Items and Inventory
func will_pickup(item):
	$Inventory.pickup(item)
func get_item(itemData):
	$Inventory.get_item(itemData)
#endregion

#region Animation

func mech_animate_play( coreAnim : String, leftArmAnim : String, leftLegAnim : String, rightArmAnim : String, rightLegAnim : String ):	
	core.play(coreAnim)
	left_arm.play(leftArmAnim)
	left_leg.play(leftLegAnim)
	right_arm.play(rightArmAnim)
	right_leg.play(rightLegAnim)
	
	
func mech_animate_pause():
	core.pause()
	left_arm.pause()
	left_leg.pause()
	right_arm.pause()
	right_leg.pause()

func play_slot_animation(slot: LimbSlot, anim_name: StringName) -> void:
	var sprite: AnimatedSprite2D = limb_sprites[slot]

	if sprite.sprite_frames.has_animation(anim_name):
		sprite.play(anim_name)

func play_mech_animation(anim_name: String) -> void:
	for slot in equipped_parts:
		var part: MechPart = equipped_parts[slot]

		if part == null:
			continue

		if part.animations.has(anim_name):
			play_slot_animation(
				slot,
				part.animations[anim_name]
			)
#endregion
