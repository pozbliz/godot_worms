# pause_menu.gd
extends Control

signal level_finished
signal main_menu_opened

@onready var resume_game_button: Button = $MarginContainer/VBoxContainer/ResumeGameButton
@onready var how_to_play_button: Button = $MarginContainer/VBoxContainer/HowToPlayButton
@onready var options_button: Button = $MarginContainer/VBoxContainer/OptionsButton
@onready var main_menu_button: Button = $MarginContainer/VBoxContainer/MainMenuButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	hide()
	
	EventBus.game_paused.connect(open)
	EventBus.how_to_play_opened.connect(close)
	EventBus.options_menu_opened.connect(close)
	EventBus.back_button_pressed.connect(open)
	EventBus.game_resumed.connect(close)

	resume_game_button.pressed.connect(_on_resume_game_button_pressed)
	how_to_play_button.pressed.connect(_on_how_to_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _unhandled_input(event: InputEvent) -> void:  # TODO: pause menu cannot be closed with ESC
	if event.is_action_pressed("open_menu"):
		_on_resume_game_button_pressed()

func open():
	show()
	resume_game_button.grab_focus()

func close():
	hide()
	
func _on_resume_game_button_pressed():
	EventBus.menu_selected.emit()
	EventBus.game_resumed.emit()
	get_tree().paused = false
	close()
	
func _on_how_to_play_button_pressed():
	EventBus.menu_selected.emit()
	EventBus.how_to_play_opened.emit()
	close()
	
func _on_options_button_pressed():
	EventBus.menu_selected.emit()
	EventBus.options_menu_opened.emit()
	close()
	
func _on_main_menu_button_pressed():
	EventBus.menu_selected.emit()
	EventBus.main_menu_opened.emit()
	close()
