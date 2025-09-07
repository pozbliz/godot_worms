extends Node


var number_of_teams: int = 2
var number_of_worms: int = 6


func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var config = ConfigFile.new()
	if config.load("user://options.cfg") == OK:
		number_of_teams = config.get_value("gameplay", "number_of_teams", true)
		number_of_worms = config.get_value("gameplay", "number_of_worms", true)

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("gameplay", "number_of_teams", number_of_teams)
	config.set_value("gameplay", "number_of_worms", number_of_worms)
	config.save("user://options.cfg")
