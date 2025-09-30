# pause_menu.gd
extends Control

signal options_menu_opened


@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton
@onready var number_teams_option: OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/NumberTeamsOption
@onready var number_worms_option: OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/NumberWormsOption


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	hide()
	
	EventBus.options_menu_opened.connect(open)
	back_button.pressed.connect(_on_back_button_pressed)
	number_teams_option.item_selected.connect(_on_settings_changed)
	number_worms_option.item_selected.connect(_on_settings_changed)


func open():
	show()
	back_button.grab_focus()

func close():
	hide()
	
func _on_settings_changed(index: int):
	SettingsManager.number_of_teams = int(number_teams_option.text)
	SettingsManager.number_of_worms = int(number_worms_option.text)
	
func _on_back_button_pressed():
	EventBus.menu_selected.emit()
	EventBus.back_button_pressed.emit()
	close()
