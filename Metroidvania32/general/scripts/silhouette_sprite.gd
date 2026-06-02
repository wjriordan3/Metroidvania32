#extends Sprite2D

#@onready var _silhouette_sprite: Sprite2D = $SilhouetteSprite

# set the initial values of the relevant properties
#func _ready() -> void:
#	_silhouette_sprite.texture = texture
#	_silhouette_sprite.offset = offset
#	_silhouette_sprite.flip_h = flip_h
#	_silhouette_sprite.hframes = hframes
#	_silhouette_sprite.vframes = vframes
#	_silhouette_sprite.frame = frame
	
# Set the silhouette sprite's properties when they are changed
#func _set(property: StringName, value: Variant) -> bool:
#	if is_instance_valid(_silhouette_sprite):
#		match property:
#			"texture":
#				_silhouette_sprite.texture = value
#			"offset": 
#				_silhouette_sprite.offset = value
#			"flip_h":
#				_silhouette_sprite.flip_h = value
#			"hframes":
#				_silhouette_sprite.hframes = value
#			"vframes":
#				_silhouette_sprite.vframes = value
#			"frame":
#				_silhouette_sprite.frame = value
#	return false

extends AnimatedSprite2D

@onready var silhouette: AnimatedSprite2D = %SilhouetteSprite

@export var shadow_color: Color = Color(0, 0, 0, 0.5) # default semi-transparent black

@onready var parent_sprite: AnimatedSprite2D = get_parent() as AnimatedSprite2D

func _ready() -> void:
	if not parent_sprite:
		push_error("SilhouetteSprite must be a child of an AnimatedSprite2D!")
		return
	
	# Use the same SpriteFrames resource
	sprite_frames = parent_sprite.sprite_frames
	animation = parent_sprite.animation
	frame = parent_sprite.frame
	flip_h = parent_sprite.flip_h
	flip_v = parent_sprite.flip_v
	offset = parent_sprite.offset
	modulate = shadow_color

	# Connect signals to keep in sync
	parent_sprite.animation_changed.connect(_on_parent_animation_changed)
	parent_sprite.frame_changed.connect(_on_parent_frame_changed)

func _on_parent_animation_changed() -> void:
	if not is_instance_valid(parent_sprite):
		return
	play(parent_sprite.animation)

func _on_parent_frame_changed() -> void:
	if not is_instance_valid(parent_sprite):
		return
	frame = parent_sprite.frame

func _process(_delta: float) -> void:
	# To keep flips and offset in sync each frame
	if not is_instance_valid(parent_sprite):
		return
	flip_h = parent_sprite.flip_h
	flip_v = parent_sprite.flip_v
	offset = parent_sprite.offset
