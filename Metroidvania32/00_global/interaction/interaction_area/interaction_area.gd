extends Area2D
class_name InteractionArea

enum Shape {
	CIRCLE,
	RECTANGLE,
	PILL
}

# Default settings
@export var action_name: String = "interact"
@export var collision_shape = Shape.CIRCLE

# Size settings
@export var rect_width = 50
@export var rect_or_pill_height = 100
@export var circle_or_pill_radius = 25

func _ready():
	# Shape variable
	var shape_var = CircleShape2D.new()
	match collision_shape:
		Shape.CIRCLE:
			# shape_var is circle by default
			shape_var.radius = circle_or_pill_radius
		Shape.RECTANGLE:
			shape_var = RectangleShape2D.new()
			shape_var.size = Vector2(rect_width, rect_or_pill_height)
		Shape.PILL:
			shape_var = CapsuleShape2D.new()
			shape_var.radius = circle_or_pill_radius
			shape_var.height = rect_or_pill_height
	
	# Set collision shape
	$CollisionShape2D.shape = shape_var

var interact: Callable = func():
	pass

func _on_body_entered(body: Node2D) -> void:
	InteractionManager.register_area(self)
	


func _on_body_exited(body: Node2D) -> void:
	InteractionManager.unregister_area(self)
