class_name Player extends CharacterBody2D

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

@onready var core: Sprite2D = $Core
@onready var right_leg: Sprite2D = $RightLeg
@onready var left_leg: Sprite2D = $LeftLeg
@onready var left_arm: Sprite2D = $LeftArm
@onready var right_arm: Sprite2D = $RightArm


@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var one_way_platform_shapecast: ShapeCast2D = $OneWayPlatformShapecast

@onready var animation_player_core: AnimationPlayer = $AnimationPlayer_Core
@onready var animation_player_left_arm: AnimationPlayer = $AnimationPlayer_LeftArm
@onready var animation_player_left_leg: AnimationPlayer = $AnimationPlayer_LeftLeg
@onready var animation_player_right_arm: AnimationPlayer = $AnimationPlayer_RightArm
@onready var animation_player_right_leg: AnimationPlayer = $AnimationPlayer_RightLeg
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
var gravity_multiplier : float = 1.0
var crouch_multiplier : float = 1.0
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

	
func add_debug_indicator( color : Color = Color.RED ) -> void:
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child( d )
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 3.0 ).timeout
	d.queue_free()
	pass
	
#region Items and Inventory
func will_pickup(item):
	$Inventory.pickup(item)
func get_item(itemData):
	$Inventory.get_item(itemData)
#endregion

#region Animation
func mech_animate_play( coreAnim : String, leftArmAnim : String, leftLegAnim : String, rightArmAnim : String, rightLegAnim : String ):
	animation_player_core.play(coreAnim)
	animation_player_left_arm.play(leftArmAnim)
	animation_player_left_leg.play(leftLegAnim)
	animation_player_right_arm.play(rightArmAnim)
	animation_player_right_leg.play(rightLegAnim)
	
func mech_animate_pause():
	animation_player_core.pause()
	animation_player_left_arm.pause()
	animation_player_left_leg.pause()
	animation_player_right_arm.pause()
	animation_player_right_leg.pause()

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
