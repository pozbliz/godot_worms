class_name FallState
extends State


func enter():
	character.play_animation("fall")
	
func handle_input(_event: InputEvent) -> void:
	if get_tree().paused:
		return
		
	character.input_direction_x = Input.get_axis("move_left", "move_right")

func physics_update(delta: float) -> void:
	if not character.turn_active:
		character.velocity.x = 0
		state_machine.change_state(character.states.idle)
		
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
