extends Node


var character = {
	"character_hit": "res://assets/sound/player/player_hit.wav",
	"character_died": "res://assets/sound/player/player_died.wav",
	"jump_pressed": "res://assets/sound/player/jump.wav",
}

var weapons = {
	"bazooka": "res://assets/weapons/bazooka_shoot.wav",
}

var world = {
	"mushroom_picked_up": "res://assets/sound/world/mushroom_picked_up.wav",
}

var music = {
	1: "res://assets/sound/music/Hillbilly Swing.mp3",
}

var menu = {
	"select": "res://assets/sound/menu/menu_select.wav"
}


func _ready() -> void:
	### CHARACTERS ###
	EventBus.character_hit.connect(_on_character_hit)
	EventBus.character_died.connect(_on_character_died)
	EventBus.jump_pressed.connect(_on_jump_pressed)
	EventBus.weapon_fired.connect(_on_weapon_fired)
	
	### WORLD ###
	
	### MUSIC ###
	EventBus.level_started.connect(_on_level_started)
	
	### MENU ###
	EventBus.menu_selected.connect(_on_menu_selected)
	

### CHARACTERS ###
func _on_character_hit():
	AudioManager.play(character["character_hit"])

func _on_character_died():
	AudioManager.stop_music()
	AudioManager.play(character["character_died"])
	
func _on_jump_pressed():
	AudioManager.play(character["jump_pressed"])
	
func _on_weapon_fired(weapon: String):
	if weapons.has(weapon):
		AudioManager.play(weapons[weapon])

### WORLD ###


### MUSIC ###
func _on_level_started(level: int):
	#AudioManager.play_music(music[level])
	pass
	

### MENU ###
func _on_menu_selected():
	AudioManager.play(menu["select"])
