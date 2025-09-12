class_name Projectile
extends Node2D


@export var projectile_data: ProjectileData

var direction: Vector2 = Vector2.ZERO
var attack_damage: int
var on_hit_effect: Node2D = null

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	$VisibleOnScreenEnabler2D.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	$HitboxComponent.area_entered.connect(_on_projectile_area_entered)
	add_to_group("projectile")
	
	attack_damage = projectile_data.damage
	if projectile_data.on_hit_script:
		on_hit_effect = projectile_data.on_hit_script.new()
		add_child(on_hit_effect)
		on_hit_effect.owner = self

func _process(delta):
	if get_tree().paused:
		return
	position += direction * projectile_data.speed * delta
	
func _on_projectile_area_entered(area):
	on_hit_effect.trigger(global_position)
	## TODO: add world collision

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
