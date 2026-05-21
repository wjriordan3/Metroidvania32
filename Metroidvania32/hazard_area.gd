class_name HazardArea extends Area2D
@export var damage : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect( _on_body_entered )
	area_entered.connect( _on_body_entered )
	monitorable = false
	set_active()
	pass # Replace with function body.

func _on_body_entered( body : Node2D ) -> void:
	print( "Body entered: ", body.name )
	if body is DamageArea:
		body.take_damage( self )
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
func _process(delta: float) -> void:
	pass
