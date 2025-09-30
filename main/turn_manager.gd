class_name TurnManager
extends Node


@export var turn_time: float = 10.0

var characters: Array[Character]
var turn_order: Array[Character]
var current_character: Character

var time_left: float = 0.0
var game_over: bool = false
var turn_count: int = 0


func _ready() -> void:
	EventBus.character_died.connect(_on_character_died)
	game_over = false
	print("turn manager ready")
	print(get_tree().paused)
	
func _unhandled_input(event: InputEvent) -> void:
	if current_character:
		current_character.state_machine._unhandled_input(event)
		get_tree().root.set_input_as_handled()
	
func start_turn() -> void:
	if game_over:
		return
		
	if turn_count == 0:
		turn_order = characters.duplicate()
	
	if turn_order.is_empty():
		EventBus.all_worms_died.emit()  # TODO: implement game over / game end
		return
		
	current_character = turn_order.pop_front()
	turn_order.append(current_character)
	
	current_character.start_turn()
	time_left = turn_time
	turn_count += 1
	
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
	if character.is_dead_handled:
		return
	character.is_dead_handled = true
	turn_order.erase(character)
	characters.erase(character)

	var alive_teams := {}
	for char in characters:
		if not char.is_dead:
			alive_teams[char.team] = true
			
	if alive_teams.size() > 1:
		return
		
	if alive_teams.size() == 1:
		var winner_team = alive_teams.keys()[0]
		game_over = true
		EventBus.game_finished.emit(winner_team)
		return
		
	if alive_teams.size() == 0:
		# No teams alive → sudden draw
		game_over = true
		EventBus.game_finished.emit(null)
		
