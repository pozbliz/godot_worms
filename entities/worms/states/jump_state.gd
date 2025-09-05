class_name JumpState
extends State


const GRAVITY: float = 1500


func handle_input(_event: InputEvent) -> void:
	if get_tree().paused:
		return
		
	character.input_direction_x = Input.get_axis("move_left", "move_right")
	
func enter():
	character.velocity.y = character.jump_velocity
	character.jump_held_time = 0.0
	character.is_jumping = true
	character.play_animation("jump")
	EventBus.jump_pressed.emit()
	
func physics_update(delta: float) -> void:
	character.velocity.x = character.speed * character.input_direction_x
	character.velocity.y += character.gravity * delta
	
	if character.is_jumping:
		character.jump_held_time += delta
		if not Input.is_action_pressed("jump") and character.velocity.y < 0:
			character.velocity.y *= 0.5
			character.is_jumping = false
		elif character.jump_held_time >= character.max_jump_hold_time:
			character.is_jumping = false
			
	if character.input_direction_x != 0:
		character.facing_direction_x = character.input_direction_x
	character.sprite.flip_h = character.facing_direction_x < 0
	
	character.move_and_slide()

	if not character.is_on_floor() and character.velocity.y >= 0:
		state_machine.change_state(character.states.fall)
