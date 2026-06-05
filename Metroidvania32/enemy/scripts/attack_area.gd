class_name AttackArea extends Area2D

@export var damage : float = 1

enum REMOVAL_METHOD { NONE, SELF, PARENT }
@export var remove_on_hit : REMOVAL_METHOD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect( _on_body_entered )
	area_entered.connect( _on_body_entered )
	set_active( false )
	pass # Replace with function body.

func _on_body_entered( body : Node2D ) -> void:
	print( "Body entered: ", body.name )
	if body is DamageArea:
		body.take_damage( self )
		var pos : Vector2 = global_position
		pos.x = body.global_position.x
		VisualEffects.hit_dust(pos)
		match remove_on_hit:
			REMOVAL_METHOD.SELF:
				_remove_on_hit()
			REMOVAL_METHOD.PARENT:
				_remove_parent_on_hit()
			_:
				pass
		pass
	pass

func activate( duration : float = 0.1 ) -> void:
	set_active()
	await get_tree().create_timer( duration ).timeout
	set_active( false )
	pass
	
func set_active( value : bool = true ) -> void:
	monitoring = value
	visible = value
	pass
	
func flip( direction_x : float ):
	if direction_x > 0:
		scale.x = 1
	elif direction_x < 0:
		scale.x = -1
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _remove_on_hit() -> void:
	queue_free()
	
func _remove_parent_on_hit() -> void:
	get_parent().queue_free()
