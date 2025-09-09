extends Node2D


@export var character_scene: PackedScene

var number_of_teams: int = 2
var number_of_worms: int = 2
var screen_size: Vector2


func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	create_level()
	create_characters()
	TurnManager.assign_teams()
	TurnManager.start_turn()

func _process(delta: float) -> void:
	pass
	
func create_level() -> void:
	pass
	
func create_characters() -> void:
	SettingsManager.load_settings()
	number_of_teams = SettingsManager.number_of_teams
	number_of_worms = SettingsManager.number_of_worms
	var total_characters: int = number_of_teams * number_of_worms
	var spawn_pos_margin: int = 100
	
	for i in range(total_characters):
		var char = character_scene.instantiate()
		$World.add_child(char)
		char.global_position.x = (i + 1) * (screen_size.x - spawn_pos_margin) / total_characters
		char.global_position.y = 100 # TODO: set spawn y position based on level?
		char.worm_id = i + 1
