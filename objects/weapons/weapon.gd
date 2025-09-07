extends Node2D


@export var weapon_data: WeaponData

var can_shoot: bool = true

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready():
	pass

func shoot(shoot_direction: Vector2):
	if not can_shoot or not weapon_data:
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
	can_shoot = false
	await get_tree().create_timer(weapon_data.cooldown).timeout
	can_shoot = true
	
func get_muzzle_position() -> Vector2:
	return $Muzzle.global_position
