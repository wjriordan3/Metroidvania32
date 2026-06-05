class_name MechaUnit extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://c71luhhdj6x5x")

@onready var anim_ctrl: MechaAnimController = $MechaAnimController

@export var loadout : MechLoadout

@onready var mech_area_collision: Area2D = $MechAreaCollision
@onready var attack_area: AttackArea = $AttackArea

@onready var limb_sprites := {
	MechLoadout.LimbSlot.CORE: $Core,
	MechLoadout.LimbSlot.LEFT_ARM: $LeftArm,
	MechLoadout.LimbSlot.RIGHT_ARM: $RightArm,
	MechLoadout.LimbSlot.LEFT_LEG: $LeftLeg,
	MechLoadout.LimbSlot.RIGHT_LEG: $RightLeg
}

# updates the appearance of the mech whenever equipment changes
func refresh_loadout_visuals():
	for slot in limb_sprites:
		var sprite : AnimatedSprite2D = limb_sprites[slot]
		var equipped : EquippedPart = loadout.get_equipped(slot)
		if equipped == null:
			sprite.visible = false
			continue
		sprite.visible = true
		if equipped.part.sprite_frames:
			sprite.sprite_frames = equipped.part.sprite_frames
		
func update_mech_rendering():
	for slot in limb_sprites.keys():
		var sprite: AnimatedSprite2D = limb_sprites[slot]
		var eq: EquippedPart = loadout.get_equipped(slot)

		if eq == null:
			sprite.visible = false
			continue

		sprite.visible = true

		var part := eq.part
		var anim_set := part.animation_set

		if anim_set == null:
			continue

		var mapped := anim_set.get_anim(anim_ctrl.current_anim)

		if mapped == "":
			continue

		if sprite.sprite_frames != part.sprite_frames:
			sprite.sprite_frames = part.sprite_frames
		
		anim_ctrl.set_frame_count(sprite)
		_apply_synced_frame(sprite, mapped)

func _apply_synced_frame(sprite: AnimatedSprite2D, anim_name: StringName):
	
	if !sprite.sprite_frames.has_animation(anim_name):
		return

	sprite.animation = anim_name

	var frame_count := sprite.sprite_frames.get_frame_count(anim_name)
	var frame := anim_ctrl.get_frame(frame_count)

	sprite.frame = frame
	
func apply_loadout(l: MechLoadout):
	print("applying mech loadout")
	l.rebuild_runtime()
	update_mech_rendering()
		
		
@onready var core: AnimatedSprite2D = $Core
@onready var right_leg: AnimatedSprite2D = $RightLeg
@onready var left_leg: AnimatedSprite2D = $LeftLeg
@onready var left_arm: AnimatedSprite2D = $LeftArm
@onready var right_arm: AnimatedSprite2D = $RightArm

@onready var enter_hint_label: Label = $EntryLabel

@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var one_way_platform_shapecast: ShapeCast2D = $OneWayPlatformShapecast

@onready var limb_health: LimbHealth = $LimbHealth

@onready var idle_state: MechaState = $States/Idle
@onready var activate_state: MechaStateActivate = $States/Activate
@onready var deactivate_state : MechaState = $States/Deactivate
#endregion

#region /// export variables (used to expose variable to inspector)
#@export var allowed_pilot_types: Array[String] = ["player", "ai"]
@export var allowed_tags: Array[String] = ["player"] # "cpu"
@export var stats : Stats
#endregion

# Status Flags
var can_attack = true
var is_attacking = false
var is_climbing = false
var is_interacting = false # for handling dialogue or object interaction

# reference to controlling pilot
var active_pilot : PilotCharacter = null
var potential_pilot = null

#region /// State Machine Variables
var states : Array[ MechaState ]
var current_state : MechaState : 
	get : return states.front()
var previous_state : MechaState :
	get : return states[ 1 ]
#endregion

#region /// Ability State Machine
@onready var ability_state_machine: AbilityStateMachine = $AbilityStates
var ability_states : Array[ AbilityState ]
var current_ability_state : AbilityState:
	get : return ability_states.front()
var previous_ability_state : AbilityState:
	get: return ability_states[ 1 ]
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
	if loadout == null:
		print("MechaUnit has no loadout assigned!")
		return

	apply_loadout(loadout)
	
	enter_hint_label.visible = false
	Messages.player_interacted.connect(_on_player_interacted)
	initialize_states()
	pass

func _unhandled_input( event: InputEvent ) -> void:
	if active_pilot == null: return
	change_state( current_state.handle_input( event ))
	pass

func _process( _delta: float) -> void:
	if active_pilot == null: return
	update_direction()
	
	anim_ctrl.update(_delta)
	
	change_state( current_state.process( _delta ) )
	update_mech_rendering()
	
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
	if active_pilot == null:
		return
	var prev_direction : Vector2 = direction 
	direction = active_pilot.get_move_input()
	#$Label.text = str(direction)
	if prev_direction.x != direction.x:
		attack_area.flip(direction.x)
		if direction.x < 0:
			core.flip_h = true
			right_leg.flip_h = true
			left_leg.flip_h = true
			left_arm.flip_h = true
			right_arm.flip_h = true
		elif direction.x > 0:
			core.flip_h = false
			right_leg.flip_h = false
			left_leg.flip_h = false
			left_arm.flip_h = false
			right_arm.flip_h = false
			
	pass

func _input(event):
	if active_pilot == null:
		return

	if event.is_action_pressed("exit_mech") && is_on_floor():
		print("exiting through _input")
		mech_area_collision.monitoring = true
		_leave_mech()
	
func _on_player_interacted( player : Player ) -> void:
	print("Player interacted with MechaUnit: ", self.name)
	if potential_pilot != player:
		return
	
	if active_pilot == player && is_on_floor():
		print("exiting through _on_player_interacted")
		mech_area_collision.monitoring = true
		_leave_mech()
		return

	# Mech empty, try to enter
	if active_pilot == null and can_be_entered_by(player):
		print("Player now entering MechaUnit: ", name)
		enter_hint_label.hide()
		mech_area_collision.monitoring = false
		_control_mech(player)
	
	pass
				
func _control_mech(pilot):
	# Assign player to pilot
	active_pilot = pilot
	pilot.on_enter_mech(self)
	change_state(idle_state)
	# Maybe assign to a cockpit position placed on mech in scene?
	#player.global_position = cockpit_marker.global_position
	pilot.global_position = self.global_position
	
func _leave_mech():
	if active_pilot == null:
		return
	var pilot := active_pilot
	pilot.on_exit_mech()
	change_state(deactivate_state)
	pilot.global_position = self.global_position
	active_pilot = null
	
func can_be_entered_by(pilot) -> bool:
	return pilot.pilot_tag in allowed_tags

func _on_mech_area_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		potential_pilot = body
		enter_hint_label.show()
		
func _on_mech_area_collision_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		potential_pilot = null
		enter_hint_label.hide()
		return
	
func add_debug_indicator( color : Color = Color.RED ) -> void:
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child( d )
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 3.0 ).timeout
	d.queue_free()
	pass

const AIM_DEADZONE := 0.2
func get_aim_direction() -> Vector2:
	# Get aim input from right stick	
	var stick := Input.get_vector(
		"aim_left",
		"aim_right",
		"aim_up",
		"aim_down"
	)
	# Ignore tiny movements
	if stick.length() > AIM_DEADZONE:
		return stick.normalized()
	else:
		# Fall back to mouse aiming
		var mouse_direction := global_position.direction_to(get_global_mouse_position())
		if mouse_direction.length() > 0.0:
			return mouse_direction.normalized()
	
	return Vector2.RIGHT if direction.x >= 0 else Vector2.LEFT

#region Limb Abilities and Stat Modifications
func equip_part(part : MechPart):
	if loadout.equip_part(part):
		refresh_loadout_visuals()
		apply_stats(part)
		apply_abilities(part)
		apply_states(part)
		apply_passives(part)
		
var abilities: Array[MechAbility] = []
func add_ability(ability : MechAbility) -> void:
	var instance = ability.duplicate()
	instance.mecha = self                         
	abilities.append(instance)

func apply_stats(_part: MechPart):
	pass

func apply_abilities( part : MechPart):
	for ability in part.abilities:
		add_ability(ability.duplicate())
		
func apply_states( part : MechPart ):
	for state_scene in part.ability_states:
		var state = state_scene.instantiate()
		ability_state_machine.add_state(state)
		
func apply_passives( part : MechPart ):
	for passive in part.passive_effects:
		passive.apply(self)

#endregion

#region Limb Input Handling

var limb_used = -1

const ATTACK_INPUTS := {
	"arm_R": 0,
	"arm_L": 1,
	"leg_R": 2,
	"leg_L": 3,
}
	
#endregion
