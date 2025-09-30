extends Node2D


@export var character_scene: PackedScene
@export var tombstone_scene: PackedScene

var number_of_teams: int = 2
var number_of_worms: int = 2
var screen_size: Vector2

@onready var turn_manager: TurnManager = $TurnManager



func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	create_level()
	create_characters()
	
	EventBus.character_died.connect(spawn_tombstone)
	turn_manager.start_turn()
	
func pause_game():
	get_tree().paused = true
	EventBus.game_paused.emit()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		pause_game()
	
func create_level() -> void:
	pass
	
func create_characters() -> void:
	number_of_teams = SettingsManager.number_of_teams
	number_of_worms = SettingsManager.number_of_worms
	var total_characters: int = number_of_teams * number_of_worms
	var spawn_pos_margin: int = 100
	var team_colors = [
		Color.RED,
		Color.BLUE,
		Color.GREEN,
		Color.YELLOW
	]
	
	for i in range(total_characters):
		var char = character_scene.instantiate()
		$World.add_child(char)
		char.global_position.x = (i + 1) * (screen_size.x - spawn_pos_margin) / total_characters
		char.global_position.y = 100
		char.worm_id = i + 1
		char.team =  i % number_of_teams + 1
		char.add_to_group("team" + str(char.team + 1))
		turn_manager.characters.append(char)
		
		# Tint by team color shader
		var team_shader := preload("res://entities/worms/team_tint.gdshader")
		var mat := ShaderMaterial.new()
		mat.shader = team_shader
		mat.set_shader_parameter("team_color", team_colors[char.team % team_colors.size()])
		mat.set_shader_parameter("tint_strength", 0.18)

		_apply_material_recursive(char, mat)
		
func _apply_material_recursive(node: Node, mat: ShaderMaterial) -> void:
	if node is Sprite2D or node is AnimatedSprite2D:
		node.material = mat
	for child in node.get_children():
		if child is Node:
			_apply_material_recursive(child, mat)
			
func spawn_tombstone(entity: Character) -> void:
	var tombstone = tombstone_scene.instantiate()
	$World.add_child(tombstone)
	tombstone.global_position = entity.global_position
	tombstone.scale = Vector2(2,2)
