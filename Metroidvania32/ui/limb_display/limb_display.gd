extends GridContainer

# Loop through limb array and set health for each
func initialize(limb_array: Array) -> void:
	var i = 0
	for limb_health in get_children():
		limb_health.initialize(limb_array[i].max_health)
		i+=1
		
func update_health(limb: Variant, health: int):
	if limb == "LEFT_ARM":
		$LeftArm.update_health(health)
	elif limb == "RIGHT_ARM":
		$RightArm.update_health(health)
	elif limb == "LEFT_LEG":
		$LeftLeg.update_health(health)
	elif limb == "RIGHT_LEG":
		$RightLeg.update_health(health)	
