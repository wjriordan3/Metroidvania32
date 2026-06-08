class_name DecisionEngineBasic extends DecisionEngine


#Included in DecisionEngine
# var enemy : Enemy
# var current_state : EnemyState
# var blackboard : Blackboard
@onready var es_walk : ESWalk = %ESWalk
@onready var es_stun : ESStun = %ESStun
@onready var es_death : ESDeath = %ESDeath
@onready var es_attack : ESAttack = %ESAttack
@onready var player_sensor : PlayerSensor = %PlayerSensor


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
		blackboard.target = player_sensor.player
	else:
		blackboard.update_distance_to_target( enemy.global_position )
		#print( blackboard.distance_to_target )
		if blackboard.distance_to_target < 60:
			#print( "Attack!")
			return es_attack
			
		if player_sensor.target_changed :
			blackboard.target = null
		
	
	return es_walk
