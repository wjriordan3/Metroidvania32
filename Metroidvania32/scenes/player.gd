extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -200.0

#Initialize inventory
var inventory : Node = $Inventory.new()
# Double jump counter
var jump_cnt : int = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		#reset jump counter when on floor
		jump_cnt = 0
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jump_cnt < 3:
		#use same velocity for first and second jump, then half velocity for third jump
		velocity.y = JUMP_VELOCITY / (1 if jump_cnt < 2 else jump_cnt )
		jump_cnt += 1
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
