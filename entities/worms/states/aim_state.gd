class_name AimState
extends State


var shoot_direction: Vector2


func enter():
	character.play_animation("idle")
	character.velocity.x = 0
	character.crosshair.show()

func handle_input(event) -> void:
	pass

func physics_update(delta: float) -> void:
	if Input.is_action_just_released("aim"):
		state_machine.change_state(character.states.idle)
	if Input.is_action_just_pressed("shoot") and character.current_weapon and character.turn_active:
		character.current_weapon.shoot(shoot_direction)
		
	character.velocity.y += character.gravity * delta
	character.move_and_slide()
	
	var mouse_pos = character.get_global_mouse_position()
	var muzzle_pos = character.current_weapon.get_muzzle_position()
	var raw_dir = (mouse_pos - muzzle_pos).normalized()
	
	var angle = character.forward.angle_to(raw_dir)
	var max_angle = PI / 2.5
	angle = clamp(angle, -max_angle, max_angle)
	
	# Update weapon rotation
	var aim_dir = character.forward.rotated(angle)
	character.current_weapon.rotation = aim_dir.angle()
	
	# Limit crosshair position along this vector
	var distance = (mouse_pos - muzzle_pos).length()
	character.crosshair.global_position = muzzle_pos + aim_dir * distance
	
	shoot_direction = aim_dir
	
func exit() -> void:
	character.crosshair.hide()
