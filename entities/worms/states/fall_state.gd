class_name FallState
extends State


func enter():
	character.play_animation("fall")

func physics_update(delta: float) -> void:
	character.input_direction_x = Input.get_axis("move_left", "move_right")
	character.velocity.x = character.speed * character.input_direction_x
	character.velocity.y += character.gravity * delta
	
	if character.input_direction_x != 0:
		character.facing_direction_x = character.input_direction_x
	character.sprite.flip_h = character.facing_direction_x < 0
	
	character.move_and_slide()

	if character.is_on_floor():
		if is_equal_approx(character.input_direction_x, 0.0):
			state_machine.change_state(character.states.idle)
		else:
			state_machine.change_state(character.states.walk)
			
func bounce():
	character.velocity.y = character.jump_velocity * 0.5
	state_machine.change_state(character.states.jump)
