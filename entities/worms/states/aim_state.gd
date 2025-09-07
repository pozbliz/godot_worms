class_name AimState
extends State


var shoot_direction: Vector2


func enter():
	character.play_animation("idle")
	character.velocity.x = 0
	character.crosshair.show()

func handle_input(event) -> void:
	if event.is_action_released("aim"):
		state_machine.change_state(character.states.idle)
		
	if event.is_action_pressed("shoot") and character.current_weapon:
		character.current_weapon.shoot(shoot_direction)

func physics_update(delta: float) -> void:
	character.velocity.y += character.gravity * delta
	character.move_and_slide()
	
	var mouse_pos = character.get_global_mouse_position()
	character.crosshair.global_position = mouse_pos
	shoot_direction = (mouse_pos - character.current_weapon.get_muzzle_position()).normalized()
	character.current_weapon.rotation = shoot_direction.angle()
	
func exit() -> void:
	character.crosshair.hide()
