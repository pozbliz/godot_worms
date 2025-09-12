extends Node2D


@export var radius: float = 18.0
@export var attack_damage: int = 15


func _ready() -> void:
	pass

func trigger(position: Vector2) -> void:
	var explosion = preload("res://objects/projectiles/on_hit_explosion.tscn").instantiate()
	var hitbox = explosion.get_node("HitboxComponent") as AttackHitbox
	var shape = hitbox.get_node("CollisionShape2D") as CollisionShape2D
	var animated_sprite_2d = explosion.get_node("AnimatedSprite2D") as AnimatedSprite2D
	
	hitbox.attack_damage = attack_damage
	explosion.global_position = position
	shape.shape.radius = radius
	var world = get_tree().current_scene.get_node("GameRoot/World")
	world.add_child(explosion)
	
	animated_sprite_2d.play("default")
	await animated_sprite_2d.animation_finished
	queue_free()
