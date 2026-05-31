# Configuration script
extends Node

const CONFIG_FILE_PATH = "user://settings.cfg"

func _ready() -> void:
	load_configuration()

#region Configuration Functions
func save_configuration() -> void:
	var config := ConfigFile.new()
	config.set_value( "audio", "music", AudioServer.get_bus_volume_linear ( 2 ) )
	config.set_value( "audio", "sfx", AudioServer.get_bus_volume_linear ( 3 ) )
	config.set_value( "audio", "ui", AudioServer.get_bus_volume_linear ( 4 ) )
	config.save( CONFIG_FILE_PATH )
	pass

func load_configuration() -> void:
	var config := ConfigFile.new()
	var err = config.load( CONFIG_FILE_PATH )
	if err != OK:
		AudioServer.set_bus_volume_linear( 2, 0.8 )
		AudioServer.set_bus_volume_linear( 3, 1.0 )
		AudioServer.set_bus_volume_linear( 4, 1.0 )
		save_configuration()
		return
		
	AudioServer.set_bus_volume_linear( 2, config.get_value( "audio", "music", 0.8 ))
	AudioServer.set_bus_volume_linear( 2, config.get_value( "audio", "sfx", 1.0 ))
	AudioServer.set_bus_volume_linear( 2, config.get_value( "audio", "ui", 1.0 ))
	
	pass
#endregion
