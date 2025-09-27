extends Control

signal main_menu_opened

@onready var main_menu_button: Button = $MarginContainer/VBoxContainer/MainMenuButton
@onready var winner_team_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/WinnerTeamLabel

enum Team {
	RED = 1,
	BLUE = 2,
	GREEN = 3,
	YELLOW = 4
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	hide()
	
	EventBus.game_finished.connect(open)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func open(team):
	get_tree().paused = true
	if not team:
		winner_team_label.text = "DRAW"
	else:
		var team_name = Team.keys()[Team.values().find(team)]
		winner_team_label.text = team_name
	show()
	main_menu_button.grab_focus()

func close():
	hide()
	
func _on_main_menu_button_pressed():
	EventBus.menu_selected.emit()
	EventBus.main_menu_opened.emit()
