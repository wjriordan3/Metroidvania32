extends NinePatchRect

var min_scrap = 0
var max_scrap = 999
var scrap_counter = 0

# refresh the label
func refresh():
	$Label.text = str(scrap_counter)

# initialize scrap counter, can't be < 0
func initialize(curr_scrap: int):
	if(curr_scrap <= min_scrap):
		scrap_counter = 0
	else:
		scrap_counter = curr_scrap
	refresh()

func _on_interface_scrap_changed(scrap: int) -> void:
	scrap_counter = scrap
	refresh()
