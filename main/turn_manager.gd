extends Node


var characters: Array[Character]
var turn_order: Array[Character]
var number_of_teams: int = 2
var number_of_worms: int = 2


func assign_to_team() -> void:
	SettingsManager.load_settings()
	number_of_teams = SettingsManager.number_of_teams
	number_of_worms = SettingsManager.number_of_worms
	
	assert (characters.size() == number_of_teams * number_of_worms)
	
	for i in range(characters.size()):
		var team = i % number_of_teams
		var chosen = characters[i]
		chosen.team = team
		chosen.add_to_group("team" + str(team))
		
	turn_order = characters
