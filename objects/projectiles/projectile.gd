class_name Projectile
extends Node2D


@export var projectile_data: ProjectileData
@export var on_hit_scenes: Array[PackedScene] = []

var direction: Vector2 = Vector2.ZERO
var attack_damage: int
var distance_traveled: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	$VisibleOnScreenEnabler2D.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	$HitboxComponent.area_entered.connect(_on_projectile_area_entered)
	$WorldCollider.area_entered.connect(_on_projectile_area_entered)
	add_to_group("projectile")
	
	attack_damage = projectile_data.damage
	
	if projectile_data.on_hit_scene and projectile_data.on_hit_scene not in on_hit_scenes:
		on_hit_scenes.append(projectile_data.on_hit_scene)

func _process(delta: float) -> void:
	if get_tree().paused:
		return
		
	var move = direction * projectile_data.speed * delta
	position += move
	distance_traveled += move.length()
	
	if projectile_data.damage_dropoff_enabled:
		$HitboxComponent.attack_damage = _calculate_damage_dropoff(distance_traveled)
		
func _calculate_damage_dropoff(distance: float) -> int:
	var max_range = projectile_data.max_range
	var min_damage_factor = 0.5

	var factor = clamp(1.0 - distance / max_range, min_damage_factor, 1.0)
	return int(projectile_data.damage * factor)

func _on_projectile_area_entered(_area: Area2D) -> void:
	var world = get_tree().current_scene.get_node("GameRoot/World")
	
	for effect_scene in on_hit_scenes:
		if effect_scene:
			var effect_instance = effect_scene.instantiate()
			world.call_deferred("add_child", effect_instance)
			effect_instance.call_deferred("trigger", global_position)
			
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
