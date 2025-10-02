extends Control


@onready var start_game_button: Button = $MarginContainer/VBoxContainer/StartGameButton
@onready var how_to_play_button: Button = $MarginContainer/VBoxContainer/HowToPlayButton
@onready var options_button: Button = $MarginContainer/VBoxContainer/OptionsButton
@onready var exit_game_button: Button = $MarginContainer/VBoxContainer/ExitGameButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	EventBus.main_menu_opened.connect(open)
	EventBus.back_button_pressed.connect(open)
	start_game_button.pressed.connect(start_game)
	how_to_play_button.pressed.connect(_on_how_to_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	exit_game_button.pressed.connect(_on_exit_game_button_pressed)
	
	open()
	
func _gui_input(event):
	if event.is_action_pressed("ui_up"):
		event.consume()
	elif event.is_action_pressed("ui_down"):
		event.consume()
	
func open():
	show()
	start_game_button.grab_focus()

func close():
	hide()
	
func _on_exit_game_button_pressed():
	EventBus.menu_selected.emit()
	get_tree().quit()

func _on_options_button_pressed():
	EventBus.menu_selected.emit()
	EventBus.options_menu_opened.emit()
	close()
	
func _on_how_to_play_button_pressed():
	EventBus.menu_selected.emit()
	EventBus.how_to_play_opened.emit()
	close()
	
func start_game():
	EventBus.game_started.emit()
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_file("res://main/main.tscn")
	
