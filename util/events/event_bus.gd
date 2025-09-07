extends Node


### CHARACTERS ###
signal character_hit
signal character_died
signal jump_pressed

### WORLD ###
# UI Signals
signal game_paused
signal game_resumed
signal options_menu_opened
signal how_to_play_opened
signal main_menu_opened
signal back_button_pressed
signal game_over
signal menu_selected
signal timer_updated(time_left)

# Gameplay Signals
signal level_started
signal weapon_fired(weapon_name)
