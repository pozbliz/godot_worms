class_name WalkState
extends State


@onready var default_weapon_position: Vector2


func enter():
	character.play_animation("walk")

func physics_update(delta: float) -> void:
	character.input_direction_x = Input.get_axis("move_left", "move_right")
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
	#character.weapon_position_node.position.x = character.default_weapon_offset.x * character.facing_direction_x
		
	character.move_and_slide()
	
	if character.is_on_floor():
		character.coyote_timer = character.coyote_time
	else:
		character.coyote_timer -= delta

	if character.coyote_timer <= 0 and character.velocity.y > 0:
		state_machine.change_state(character.states.fall)
	elif Input.is_action_just_pressed("jump") and character.coyote_timer > 0:
		state_machine.change_state(character.states.jump)
	elif is_equal_approx(character.input_direction_x, 0.0):
		state_machine.change_state(character.states.idle)
	
