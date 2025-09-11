class_name IdleState
extends State


func enter():
	character.velocity.x = 0.0
	character.play_animation("idle")
	
func handle_input(event) -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(character.states.jump)
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_state(character.states.walk)

func physics_update(delta: float) -> void:
	if not character.turn_active:
		character.velocity.x = 0
		character.velocity.y += character.gravity * delta
		character.move_and_slide()
		if character.is_on_floor():
			return
		else:
			state_machine.change_state(character.states.fall)
		return
		
	if Input.is_action_pressed("aim") and character.current_weapon and character.turn_active:
		character.aim()
	character.velocity.y += character.gravity * delta
	character.forward = Vector2(character.facing_direction_x, 0)
	character.move_and_slide()

	if not character.is_on_floor():
		state_machine.change_state(character.states.fall)
