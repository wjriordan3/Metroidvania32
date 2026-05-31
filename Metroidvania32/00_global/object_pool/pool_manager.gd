# PoolManager.gd
extends Node

# Dictionary to store scenes to pool
@export var scene_templates: Dictionary = {}
# Initial size of each pool
@export var initial_pool_sizes: Dictionary = {}

# The pool itself. Uses scene path as key with array of objects as value
var pools: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize pool for each registered scene
	for scene_path in scene_templates.keys():
			var scene = scene_templates[scene_path]
			var pool_size = initial_pool_sizes.get(scene_path, 10) # Default size is 10
			
			pools[scene_path] = []
			for i in range(pool_size):
				var obj = scene.instantiate()
				obj.name = "%s_%d" % [obj.name, i]
				# Pass reference to pool manager
				if obj.has_method("set_pool_manager"):
					obj.set_pool_manager(self)
				add_child(obj)
				_deactivate_object(obj)
				pools[scene_path].append(obj)
			
			print("Pool initialized for '%s' with %d objects." % [scene_path, pool_size])
			
# Retrieve object from pool
func get_object(scene_path: String) -> Node:
	if not pools.has(scene_path) or pools[scene_path].is_empty():
		printerr("Pool for '%s' is empty or does not exist. Instantiating a new object." % scene_path)
		# If pool is empty, dynamically create new object (fallback)
		if not scene_templates.has(scene_path):
			printerr("Scene template for '%s' not found!" % scene_path)
			return null
		var new_obj = scene_templates[scene_path].instantiate()
		if new_obj.has_method("set_pool_manager"):
			new_obj.set_pool_manager(self)
		add_child(new_obj) # New objects also become manager's children
		return new_obj
		
	var obj = pools[scene_path].pop_back()
	_activate_object(obj)
	return obj
	
# Return object to pool
func return_object(obj: Node, scene_path: String):
	if not pools.has(scene_path):
		printerr("Trying to return an object to a non-existent pool: '%s'" % scene_path)
		obj.queue_free() # Must destroy if pool doesn't exist
		return
		
	# Just in case, check if already in pool
	if obj in pools[scene_path]:
		printerr("Object is already in the pool. Aborting return." % obj.name)
		return
		
	_deactivate_object(obj)
	pools[scene_path].append(obj)
	
# Internal function to deactivate object
func _deactivate_object(obj: Node):
	obj.hide()
	obj.set_process_mode(Node.PROCESS_MODE_DISABLED)
	# Disable collision shapes (find CollisionShape2D/3D children)
	_set_collision_shapes_disabled(obj, true)
	
	if obj.has_method("reset"):
		obj.reset()
		
# Internal function to activate object
func _activate_object(obj: Node):
	obj.show()
	obj.set_process_mode(Node.PROCESS_MODE_INHERIT)
	_set_collision_shapes_disabled(obj, false)
	
# Toggle CollisionShape2D/3D enabled/disabled
func _set_collision_shapes_disabled(node: Node, disabled: bool):
	for child in node.get_children():
		if child is CollisionShape2D or child is CollisionShape3D:
			child.set_deferred("disabled", disabled)
		_set_collision_shapes_disabled(child, disabled)
