class_name MechaStateAttack extends MechaState

#const ATTACK = preload()

@export var combo_time_window : float = 0.2
@export var speed : float = 150
var timer : float = 0
var combo : int = 0

func init() -> void:
	
	pass
	
# What happens when we enter this state?
func enter() -> void:
	execute_attack()
	#mecha.anim_ctrl.animation_finished.connect(_on_animation_finished)
	
	
	pass
	
# What happens when we exit this state?
func exit() -> void:
	timer = 0
	combo = 0
	#mecha.anim_ctrl.animation_finished.disconnect(_on_animation_finished)
	#next_state = null
	
	next_state = idle
	pass 
	
func handle_input( _event : InputEvent ) -> MechaState:
	combo_input(_event)
	return null
	
func process( _delta: float) -> MechaState:
	timer -= _delta
	return next_state
	 
	
func physics_process( _delta: float) -> MechaState:
	mecha.velocity.x = mecha.direction.x * speed
	return null
	
func execute_attack() -> void:
	match mecha.limb_used:
		0:
			var anim_name : String = "rightArm"
			if combo > 1:
				anim_name = "leftArm"
			mecha.anim_ctrl.play(anim_name, false)
			pass
		1:
			mecha.anim_ctrl.play("leftArm", false)
			pass
		2:
			mecha.anim_ctrl.play("rightLeg", false)
			pass
		3:
			mecha.anim_ctrl.play("leftLeg", false)
			pass
		_:
			mecha.anim_ctrl.play("rightArm", false)
	
	mecha.attack_area.activate(0.4)
	
	#Audio.play_spatial_sound(AUDIO_ATTACK, mecha.global_position)
	
	
func combo_input( _event : InputEvent ) -> void:
	if _event.is_action_pressed("arm_R"):
		mecha.limb_used = 0
		update_combo_timer()
		#return attack
	
	if _event.is_action_pressed("arm_L"):
		mecha.limb_used = 1
		update_combo_timer()
		#return attack
		
	if _event.is_action_pressed("leg_L"):
		mecha.limb_used = 2
		update_combo_timer()
		#return attack
		
	if _event.is_action_pressed("leg_R"):
		mecha.limb_used = 3
		update_combo_timer()
		#return attack

	return 
	
func update_combo_timer() -> void:
	timer = combo_time_window
	pass

func end_attack() -> void:
	if timer > 0: # if timer > 0, attack button pressed within window
		combo = wrapi( combo + 1, 0, 3 )
		execute_attack()
	else:
		next_state = idle
		#mecha.change_state(idle)
	pass
	
func _on_animation_finished( _anim_name : StringName ) -> void:
	print("finished attack animation: ", _anim_name)
	end_attack()
	pass
	
