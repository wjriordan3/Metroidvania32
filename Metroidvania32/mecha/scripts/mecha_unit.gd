class_name MechaUnit extends CharacterBody2D

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

@onready var idle_state: MechaState = $States/Idle
@onready var deactivate_state : MechaState = $States/Deactivate
#endregion


#region /// export variables (used to expose variable to inspector)
#@export var allowed_pilot_types: Array[String] = ["player", "ai"]
@export var allowed_tags: Array[String] = ["player"] 
@export var stats : Stats
#endregion

# Status Flags
var can_attack = true
var is_attacking = false
var is_climbing = false
var is_interacting = false # for handling dialogue or object interaction

# reference to controlling pilot
var active_pilot = null
var potential_pilot = null

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
	enter_hint_label.visible = false
	Messages.player_interacted.connect(_on_player_interacted)
	#initialize states
	initialize_states()
	pass

func _unhandled_input( event: InputEvent ) -> void:
	if active_pilot == null: return
	change_state( current_state.handle_input( event ))
	pass

func _process( _delta: float) -> void:
	if active_pilot == null: return
	update_direction()
	change_state( current_state.process( _delta ) )
	pass
	
func _physics_process( _delta: float ) -> void:
	if active_pilot == null: return
	velocity.y += gravity * _delta * gravity_multiplier
	velocity.y = clampf(velocity.y, -10000, stats.max_fall_velocity)
	move_and_slide()
	change_state( current_state.physics_process( _delta ) )
	pass 

func initialize_states() -> void:
	states = []
	# Gather all states
	for c in $States.get_children():
		if c is MechaState:
			states.append( c )
			c.mecha = self
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
	if active_pilot == null:
		return

	if event.is_action_pressed("action") && is_on_floor():
		_leave_mech()
	
func _on_player_interacted( player : Player ) -> void:
	print("Player interacted with MechaUnit: ", self.name)
	if potential_pilot != player:
		return
	
	if active_pilot == player && is_on_floor():
		_leave_mech()
		return

	# Mech empty, try to enter
	if active_pilot == null and can_be_entered_by(player):
		print("Player now entering MechaUnit: ", name)
		_control_mech(player)
	
	pass
		
func set_pilot(new_pilot):
	active_pilot = new_pilot
		
func _control_mech(pilot):
	change_state(idle_state) # TODO: Change to activate state
	
	# Assign player to pilot
	active_pilot = pilot
	# Hide player
	active_pilot.visible = false
	active_pilot.process_mode = Node.PROCESS_MODE_DISABLED

	# Maybe assign to a cockpit position placed on mech in scene?
	#player.global_position = cockpit_marker.global_position
	pilot.global_position = self.global_position
	
	# Switch camera target to mech
	CameraManager.set_target(self)
	CameraManager.set_zoom(Vector2.ONE)
	
func _leave_mech():
	if active_pilot == null:
		return
	
	var player = active_pilot
	# Change state here
	change_state(deactivate_state)
	
	player.global_position = self.global_position
	
	player.visible = true
	player.process_mode = Node.PROCESS_MODE_INHERIT
	
	player.current_mech = null
	active_pilot = null
	
	# Switch to main player camera
	CameraManager.set_target(player)
	CameraManager.set_zoom(Vector2.ONE)
	
func can_be_entered_by(pilot) -> bool:
	return pilot.pilot_tag in allowed_tags

func _on_mech_area_collision_body_entered(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		potential_pilot = body
		enter_hint_label.show()
		

func _on_mech_area_collision_body_exited(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		potential_pilot = null
		enter_hint_label.hide()
	
func add_debug_indicator( color : Color = Color.RED ) -> void:
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child( d )
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 3.0 ).timeout
	d.queue_free()
	pass

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
