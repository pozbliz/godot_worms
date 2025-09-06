extends Area2D


@export var projectile_data: ProjectileData

var direction: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	$VisibleOnScreenEnabler2D.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	$HitboxComponent.area_entered.connect(_on_projectile_area_entered)
	add_to_group("projectile")

func _process(delta):
	if get_tree().paused:
		return
	position += direction * projectile_data.speed * delta
	
func _on_projectile_area_entered(area):
	if area is HurtboxComponent:
		var attack = Attack.new()
		attack.attack_damage = projectile_data.damage
		area.damage(attack)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
