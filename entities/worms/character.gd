class_name Character
extends CharacterBody2D


@export var speed: float = 150.0
@export var jump_velocity: float = -500.0
@export var gravity: float = 1200.0
@export var acceleration: float = 0.2
@export var coyote_time: float = 0.1
@export var max_jump_hold_time: float = 0.2
@export var max_health: float = 1.0

var attack_damage: int = 1
var coyote_timer: float = 0.0
var input_direction_x: float
var facing_direction_x: float = 1.0
var jump_held_time: float = 0.0
var is_jumping: bool = false
var is_dead: bool = false
var invincibility_timer: float = 1.0
var is_invincible: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var world_collider: CollisionShape2D = $CollisionShape2D
@onready var state_machine = $StateMachine
@onready var states = {
	"idle": $StateMachine/Idle,
	"walk": $StateMachine/Walk,
	"jump": $StateMachine/Jump,
	"fall": $StateMachine/Fall,
}
@onready var viewport_size: Vector2 = get_viewport_rect().size


func _ready() -> void:
	state_machine.change_state(states.idle)
	add_to_group("character")
	
func _unhandled_input(_event: InputEvent) -> void:
	if get_tree().paused:
		return
		
func _physics_process(delta: float) -> void:
	if not is_dead and global_position.y > viewport_size.y:
		die()
		
func play_animation(action: String) -> Signal:
	animation_player.play(action)
		
	return animation_player.animation_finished
	
	pass
	
func take_damage() -> void:
	if is_invincible:
		return
		
	# TODO: add hp and other components
		
	is_invincible = true
	var timer = get_tree().create_timer(invincibility_timer)
	hit_flash(5)
	timer.timeout.connect(_end_invincibility)
	
func _end_invincibility() -> void:
	is_invincible = false
	
func hit_flash(blinks: int):
	for i in range(0, blinks):
		sprite.material.set("shader_parameter/flash", true)
		await get_tree().create_timer(0.10).timeout
		sprite.material.set("shader_parameter/flash", false)
		await get_tree().create_timer(0.10).timeout
	
func die() -> void:
	if is_dead:
		return
		
	is_dead = true
	
	state_machine.set_process(false)
	state_machine.set_physics_process(false)
	
	#play_animation("death")
	EventBus.character_died.emit()
	
func respawn():
	is_dead = false
	is_invincible = false
