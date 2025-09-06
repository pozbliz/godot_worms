# weapon.gd
extends Node2D

@export var weapon_data: WeaponData
var can_shoot := true

func _ready():
	pass

func shoot():
	if not can_shoot or not weapon_data:
		return

	# Spawn projectile
	var projectile = weapon_data.projectile_scene.instantiate()
	var muzzle_global = $Marker2D.global_position
	projectile.global_position = muzzle_global
	add_child(projectile)

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
