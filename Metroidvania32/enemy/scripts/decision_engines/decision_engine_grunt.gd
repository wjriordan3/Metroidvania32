class_name DecisionEngineGrunt
extends DecisionEngine


#Included in DecisionEngine
# var enemy : Enemy
# var current_state : EnemyState
# var blackboard : Blackboard
@onready var es_walk : ESWalk = %ESWalk
@onready var es_stun : ESStun = %ESStun
@onready var es_death : ESDeath = %ESDeath
@onready var es_idle : ESIdle = %ESIdle
@onready var es_shoot : ESShoot = %ESShoot
@onready var es_chase : ESChase = %ESChase
@onready var player_sensor : PlayerSensor = %PlayerSensor
@export var patrol : bool = true

func _ready() -> void :
	await super() #setup
	#Implementation
	pass
	
func decide() -> EnemyState :
	if blackboard.damage_source:
		if blackboard.health <= 0:
			return es_death
		else:
			return es_stun
	
	if current_state is ESDeath or not blackboard.can_decide:
		return null
	
	if blackboard.edge_detected:
		enemy.change_dir( -blackboard.dir )
	
	if not blackboard.target :
		if player_sensor.player:
			blackboard.target = player_sensor.player
	else:
		blackboard.update_distance_to_target( enemy.global_position )
		#print( blackboard.distance_to_target )
		if blackboard.distance_to_target < 100 and blackboard.is_level_with_target( enemy.global_position ):
			#print( "Attack!")
			return es_shoot
		elif blackboard.distance_to_target < 200 or not blackboard.is_level_with_target( enemy.global_position ):
			return es_chase
			
		if player_sensor.target_changed :
			blackboard.target = null
		
	if patrol :
		return es_walk
	return es_idle
