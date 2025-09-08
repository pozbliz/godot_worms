extends Node


var characters: Array[Character]
var turn_order: Array[Character]
var number_of_teams: int = 2
var number_of_worms: int = 2
var current_character: Character

var turn_time: float = 30.0
var time_left: float = 0.0


func _ready() -> void:
	EventBus.character_died.connect(_on_character_died)

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
		
	turn_order = characters.duplicate()
	
func start_turn() -> void:
	current_character = turn_order.pop_front()
	turn_order.append(current_character)
	
	current_character.start_turn()
	time_left = turn_time
	
func end_turn() -> void:
	if current_character:
		current_character.end_turn()
		current_character = null

	start_turn()
	
func _process(delta: float) -> void:
	if current_character:
		time_left -= delta
		EventBus.timer_updated.emit(time_left)
		if time_left <= 0:
			end_turn()
	
func _on_character_died(character: Character) -> void:
	turn_order.erase(character)
