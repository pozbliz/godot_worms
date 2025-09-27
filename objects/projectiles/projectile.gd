class_name Projectile
extends Node2D


@export var projectile_data: ProjectileData
@export var on_hit_scenes: Array[PackedScene] = []

var direction: Vector2 = Vector2.ZERO
var attack_damage: int

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	$VisibleOnScreenEnabler2D.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)
	$HitboxComponent.area_entered.connect(_on_projectile_area_entered)
	add_to_group("projectile")
	
	attack_damage = projectile_data.damage
	
	if projectile_data.on_hit_scene and projectile_data.on_hit_scene not in on_hit_scenes:
		on_hit_scenes.append(projectile_data.on_hit_scene)

func _process(delta: float) -> void:
	if get_tree().paused:
		return
		
	position += direction * projectile_data.speed * delta

func _on_projectile_area_entered(area: Area2D) -> void:
	var world = get_tree().current_scene.get_node("GameRoot/World")
	
	for effect_scene in on_hit_scenes:
		if effect_scene:
			var effect_instance = effect_scene.instantiate()
			world.add_child(effect_instance)
			effect_instance.trigger(global_position)
			
	# TODO: add world collision if needed
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
