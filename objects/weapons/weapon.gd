extends Node2D


@export var weapon_data: WeaponData

var on_cooldown: bool = false
var shots_taken: int = 0

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready():
	pass

func shoot(shoot_direction: Vector2):
	if on_cooldown or shots_taken >= weapon_data.number_of_shots or not weapon_data:
		return

	var projectile = weapon_data.projectile_scene.instantiate()
	var muzzle_global = $Muzzle.global_position
	var world = get_tree().current_scene.get_node("GameRoot/World")
	world.add_child(projectile)
	projectile.global_position = muzzle_global
	projectile.direction = shoot_direction
	projectile.rotation = rotation

	EventBus.weapon_fired.emit(weapon_data.name)  # TODO: add weapon fired to eventbus

	# Optional VFX
	if weapon_data.shoot_vfx:
		var vfx = weapon_data.shoot_vfx.instantiate()
		vfx.global_position = muzzle_global
		add_child(vfx)

	# Cooldown
	shots_taken += 1
	
	if shots_taken < weapon_data.number_of_shots:
		on_cooldown = true
		await get_tree().create_timer(weapon_data.cooldown).timeout
		on_cooldown = false
	
func get_muzzle_position() -> Vector2:
	return $Muzzle.global_position
