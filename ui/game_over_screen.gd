# pause_menu.gd
extends Control

signal main_menu_opened

@onready var main_menu_button: Button = $MarginContainer/VBoxContainer/MainMenuButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	hide()
	
	EventBus.game_over.connect(open)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func open():
	show()
	main_menu_button.grab_focus()

func close():
	hide()
	
func _on_main_menu_button_pressed():
	EventBus.menu_selected.emit()
	EventBus.main_menu_opened.emit()
