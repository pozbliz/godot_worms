extends Node


var characters: Array[Character]
var turn_order: Array[Character]
var number_of_teams: int = 2
var number_of_worms: int = 2
var current_character: Character

var turn_time: float = 30.0
var time_left: float = 0.0

var game_over: bool = false


func _ready() -> void:
	EventBus.character_died.connect(_on_character_died)
	
func _unhandled_input(event: InputEvent) -> void:
	if current_character:
		current_character.state_machine._unhandled_input(event)
		get_tree().root.set_input_as_handled()

func assign_teams() -> void:
	SettingsManager.load_settings()
	number_of_teams = SettingsManager.number_of_teams
	number_of_worms = SettingsManager.number_of_worms
	
	assert (characters.size() == number_of_teams * number_of_worms)
	
	game_over = false
	
	for i in range(characters.size()):
		var team = i % number_of_teams
		var chosen = characters[i]
		
	turn_order = characters.duplicate()
	
func start_turn() -> void:
	if game_over:
		return
	
	if turn_order.is_empty():
		EventBus.all_worms_died.emit()  # TODO: implement game over / game end
		
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
		var seconds_left := int(ceil(time_left))
		EventBus.timer_updated.emit(seconds_left)
		if time_left <= 0:
			end_turn()
	
func _on_character_died(character: Character) -> void:
	turn_order.erase(character)

	var alive_teams := {}
	for char in turn_order:
		if not char.is_dead:
			alive_teams[char.team] = true
			
	if alive_teams.size() > 1:
		return
		
	if alive_teams.size() == 1:
		var winner_team = alive_teams.keys()[0]
		game_over = true
		EventBus.game_finished.emit(winner_team)
		return
		
	# No teams alive → sudden draw
	game_over = true
	EventBus.game_finished.emit(null)
