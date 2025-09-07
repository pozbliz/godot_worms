class_name Character
extends CharacterBody2D


@export var speed: float = 150.0
@export var jump_velocity: float = -500.0
@export var gravity: float = 1200.0
@export var acceleration: float = 0.2
@export var coyote_time: float = 0.1
@export var max_jump_hold_time: float = 0.2
@export var max_health: float = 1.0
@export var weapon_scenes: Array[PackedScene]

var attack_damage: int = 1
var coyote_timer: float = 0.0
var input_direction_x: float
var facing_direction_x: float = 1.0
var jump_held_time: float = 0.0
var is_jumping: bool = false
var is_dead: bool = false
var invincibility_timer: float = 1.0
var is_invincible: bool = false
var current_weapon: Node = null
var current_weapon_index: int = 0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var world_collider: CollisionShape2D = $CollisionShape2D
@onready var state_machine = $StateMachine
@onready var states = {
	"idle": $StateMachine/Idle,
	"walk": $StateMachine/Walk,
	"jump": $StateMachine/Jump,
	"fall": $StateMachine/Fall,
	"aim": $StateMachine/Aim,
}
@onready var viewport_size: Vector2 = get_viewport_rect().size
@onready var weapon_position: Marker2D = $WeaponPosition
@onready var weapon_position_x_default: float = weapon_position.position.x
@onready var crosshair: Sprite2D = $Crosshair


func _ready() -> void:
	state_machine.change_state(states.idle)
	add_to_group("character")
	
	equip_weapon(0)
	
	crosshair.hide()
	
func _unhandled_input(_event: InputEvent) -> void:
	if get_tree().paused:
		return
		
	if Input.is_action_just_pressed("aim") and current_weapon:
		aim()
		
func _physics_process(delta: float) -> void:
	if not is_dead and global_position.y > viewport_size.y:
		die()
		
	var dir: float = 1.0
	if facing_direction_x < 0.0:
		dir = -1.0
	weapon_position.position.x = weapon_position_x_default * dir
	current_weapon.sprite_2d.flip_h = facing_direction_x < 0.0
	
	print("character pos: ", global_transform)
		
func play_animation(action: String) -> Signal:
	sprite.play(action)
		
	return sprite.animation_finished
	
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
		
func equip_weapon(index: int):
	if index < 0 or index >= weapon_scenes.size():
		return
	if current_weapon:
		current_weapon.queue_free()
	current_weapon = weapon_scenes[index].instantiate()
	weapon_position.add_child(current_weapon)
	current_weapon.position = Vector2.ZERO
	current_weapon_index = index
	
func aim():
	state_machine.change_state(states.aim)
	
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
