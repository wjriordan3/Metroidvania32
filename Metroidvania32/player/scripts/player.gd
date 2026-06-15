class_name Player extends PilotCharacter

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
var ceiling_grab_buffer : float = 0.0
const CEILING_GRAB_BUFFER_TIME := 0.15
#endregion 

# Bomb vars and consts
const BOMB_SCENE = preload("res://combat/bomb/bomb.tscn")
var bomb_unlocked = true # should be false by default but set to true for now for testing
var max_bombs = 3
var active_bombs = 0

func _ready() -> void:
	add_to_group("player")
	initalize_states()
	Messages.back_to_title_screen.connect(queue_free)
	damage_area.damage_taken.connect( _on_damage_taken )
	PlayerManager.INVENTORY_DATA.equipment_changed.connect( _on_equipment_changed )
	CameraManager.set_target(self)
	stats.health = stats.current_max_health
	
	
	if OS.is_debug_build():
		$Label.visible = true
	pass

func _unhandled_input( event: InputEvent ) -> void:
	if event.is_action_pressed( "interact" ):
		Messages.player_interacted.emit( self )

	# Bomb input = down + arm_L (H)
	if bomb_unlocked:
		if event.is_action_pressed("arm_L"):
			if Input.is_action_pressed("down"):
				spawn_bomb()
	
	if OS.is_debug_build():
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
			elif event.keycode == KEY_0:
				if Input.is_key_pressed(KEY_0):
					PlayerManager.move_player_to_spawn_position()
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
	
	# ceiling grab buffering
	if ceiling_grab_buffer > 0.0:
		ceiling_grab_buffer = maxf(
			0.0,
			ceiling_grab_buffer - _delta
	)
	
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
	if OS.is_debug_build():
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

func spawn_bomb() -> void:
	if active_bombs >= max_bombs:
		return

	var bomb = BOMB_SCENE.instantiate()
	get_tree().current_scene.add_child(bomb)
	bomb.global_position = global_position
	active_bombs += 1
	bomb.tree_exited.connect(_on_bomb_removed)

func _on_bomb_removed() -> void:
	active_bombs = max(active_bombs - 1, 0)

func is_climb_ceiling():
	print(ceiling_ray_cast_2d.is_colliding())
	return ceiling_ray_cast_2d.is_colliding() and is_on_ceiling()
	

func update_direction():
	var prev_direction : Vector2 = direction 
	# negative x is left, positive x is right, negative y is up, positive y is down
	# calculating axis to help avoid deadzone/stick drift issues for gamepads
	direction = get_move_input()
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
	
func _on_damage_taken( attack_area : AttackArea ) -> void:
	if current_state == current_state.death:
		return
	stats.take_damage(attack_area.damage)
	damage_taken.emit()
	print("Player took damage: ", stats.health)
	pass
	
func try_ceiling_hang() -> bool:
	if ceiling_ray_cast_2d.is_colliding() \
	and ceiling_grab_buffer > 0.0:
		ceiling_grab_buffer = 0.0
		return true
	return false
	
#region Pilot Functions
func get_move_input() -> Vector2:
	return Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

func get_left_arm_input() -> bool:
	return Input.is_action_just_pressed("left_arm")

func get_right_arm_input() -> bool:
	return Input.is_action_just_pressed("right_arm")

func get_left_leg_input() -> bool:
	return Input.is_action_just_pressed("left_leg")

func get_right_leg_input() -> bool:
	return Input.is_action_just_pressed("right_leg")
	
func on_enter_mech(mech: MechaUnit) -> void:
	super(mech)
	activePlayer = false
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	
	# have mech act as player
	remove_from_group("player")
	mech.add_to_group("player")
	
	Messages.input_target_changed.emit(mech)
	
		# Switch camera target to mech
	CameraManager.set_target(mech)
	CameraManager.set_zoom(Vector2.ONE)

func on_exit_mech() -> void:
	super()
	activePlayer = true
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
	
	# Remove mech from "player" group if it still has it
	for mech in get_tree().get_nodes_in_group("player"):
		if mech is MechaUnit:
			mech.remove_from_group("player")

	# Put player back in the "player" group
	add_to_group("player")
	
	Messages.input_target_changed.emit(self)
	
	# Switch to main player camera
	CameraManager.set_target(self)
	CameraManager.set_zoom(Vector2.ONE)

#endregion

func _on_equipment_changed() -> void:
	print("could update player stats here")
	
	if PlayerManager.mecha != null:
		print("Updating Player Current Piloted Mecha Visuals: ", PlayerManager.mecha)
		PlayerManager.mecha.update_equipment()
		pass
