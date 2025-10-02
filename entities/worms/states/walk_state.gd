class_name WalkState
extends State


@onready var default_weapon_position: Vector2


func enter():
	character.play_animation("walk")
	
func physics_update(delta: float) -> void:
	if not character.turn_active:
		character.velocity.x = 0
		character.velocity.y += character.gravity * delta
		character.move_and_slide()

		if character.is_on_floor():
			state_machine.change_state(character.states.idle)
		else:
			state_machine.change_state(character.states.fall)
		return
		
	if character.input_direction_x != 0:
		character.velocity.x = lerp(
			character.velocity.x, 
			character.speed * character.input_direction_x, 
			character.acceleration
		)
	character.velocity.y += character.gravity * delta
	if character.input_direction_x != 0:
		character.facing_direction_x = character.input_direction_x
	character.sprite.flip_h = character.facing_direction_x < 0
	
	character.move_and_slide()
	
	if character.is_on_floor():
		character.coyote_timer = character.coyote_time
	else:
		character.coyote_timer -= delta

	if character.coyote_timer <= 0 and character.velocity.y > 0:
		state_machine.change_state(character.states.fall)
	character.input_direction_x = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("jump") and character.coyote_timer > 0:
		state_machine.change_state(character.states.jump)
	if Input.is_action_pressed("aim") and character.current_weapon and character.turn_active:
		character.aim()
	elif is_equal_approx(character.input_direction_x, 0.0):
		state_machine.change_state(character.states.idle)
	
