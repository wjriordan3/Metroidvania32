extends Node

@warning_ignore_start("unused_signal")
signal player_interacted( player : Player )
signal pilot_interacted( pilot : Node )
signal player_healed( amount : float )
signal player_health_changed( hp : float, max_hp : float)
signal input_hint_changed( hint : String )
signal item_pickup( item : ItemData )
signal back_to_title_screen()
signal show_notification()
@warning_ignore_restore("unused_signal")
