class_name IdleState
extends State


func enter():
	character.velocity.x = 0.0
	character.play_animation("idle")
	
func handle_input(event) -> void:
	if Input.is_action_just_pressed("aim") and character.current_weapon:
		character.aim()
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(character.states.jump)
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_state(character.states.walk)

func physics_update(_delta: float) -> void:
	character.velocity.y += character.gravity * _delta
	character.forward = Vector2(character.facing_direction_x, 0)
	character.move_and_slide()

	if not character.is_on_floor():
		state_machine.change_state(character.states.fall)
