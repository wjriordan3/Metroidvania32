class_name PlayerStateDeath extends PlayerState

# const DEATH_AUDIO = preload()
const DEATH_JUMP_VELOCITY := -500.0

const GRAVITY := 980.0

const NORMAL_DEATH_JUMP := -500.0

# for a team rocket blasting off again effect
const WILD_DEATH_CHANCE := 0.25
const WILD_X_MIN := -400.0
const WILD_X_MAX := 400.0
const WILD_Y_MIN := -700.0
const WILD_Y_MAX := -400.0

var spin_speed : float = 0.0

var wild_death := randf() < 0.25  # 25% chance

func init() -> void:
	pass
	
# What happens when we enter this state?
func enter() -> void:
	# Play animation here
	player.sprite.play("death")
	# Audio.play_spatial_sound( DEATH_AUDIO, player.global_position )
	# Audio.play_music ( null ) # will transition to no music

	player.velocity = Vector2.ZERO
	player.rotation = 0.0

	# Chance for a chaotic death launch
	if randf() < WILD_DEATH_CHANCE:
		player.velocity.x = randf_range(WILD_X_MIN, WILD_X_MAX)
		player.velocity.y = randf_range(WILD_Y_MIN, WILD_Y_MAX)

		# Random spin direction and speed
		spin_speed = randf_range(8.0, 20.0)
		if randf() < 0.5:
			spin_speed *= -1.0
	else:
		player.velocity.y = NORMAL_DEATH_JUMP
		spin_speed = 0.0

	_show_game_over()
	
# What happens when we exit this state?
func exit() -> void:
	player.rotation = 0.0
	pass 
	
func handle_input( _event : InputEvent ) -> PlayerState:
	return null
	
func process( _delta: float) -> PlayerState:
	return null
	
func physics_process( delta: float) -> PlayerState:
	player.velocity.y += GRAVITY * delta
	if spin_speed != 0.0:
		player.rotation += spin_speed * delta
	player.move_and_slide()
	return null
	

func _show_game_over() -> void:
	await get_tree().create_timer(2.0).timeout
	PlayerHUD.show_game_over()
	
