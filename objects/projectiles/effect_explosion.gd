extends Node2D


@export var radius: int = 46
@export var attack_damage: int = 30

var polygon : PackedVector2Array


func trigger(pos: Vector2) -> void:
	global_position = pos
	call_deferred("_setup_effect")

func _setup_effect() -> void:
	var shape = $HitboxComponent/CollisionShape2D as CollisionShape2D
	var sprite = $AnimatedSprite2D as AnimatedSprite2D
	polygon = $Polygon2D.polygon

	shape.shape.radius = radius

	sprite.play("default")
	EventBus.weapon_fired_hit.emit("explosion")
	EventBus.explosion_triggered.emit(polygon, self)
	sprite.animation_finished.connect(Callable(self, "queue_free"))
