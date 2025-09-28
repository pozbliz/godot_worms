extends Node2D


@export var radius: int = 46
@export var attack_damage: int = 30


func trigger(position: Vector2) -> void:
	global_position = position
	call_deferred("_setup_effect")

func _setup_effect() -> void:
	var shape = $HitboxComponent/CollisionShape2D as CollisionShape2D
	var sprite = $AnimatedSprite2D as AnimatedSprite2D

	shape.shape.radius = radius

	sprite.play("default")
	sprite.animation_finished.connect(Callable(self, "queue_free"))
