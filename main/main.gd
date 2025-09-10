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
		char.global_position.y = 100 # TODO: set spawn y position based on level?
		char.worm_id = i + 1
		char.team =  i % number_of_teams
		char.add_to_group("team" + str(char.team + 1))
		
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
