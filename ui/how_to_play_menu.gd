# pause_menu.gd
extends Control

signal options_menu_opened

@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	hide()
	
	EventBus.how_to_play_opened.connect(open)
	back_button.pressed.connect(_on_back_button_pressed)

func open():
	show()
	back_button.grab_focus()

func close():
	hide()
	
func _on_back_button_pressed():
	EventBus.menu_selected.emit()
	EventBus.back_button_pressed.emit()
	close()
