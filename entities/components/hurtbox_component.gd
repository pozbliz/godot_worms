class_name HurtboxComponent
extends Area2D


@export var health_component: HealthComponent


func _ready():
	area_entered.connect(_on_hurtbox_component_area_entered)
	
func _on_hurtbox_component_area_entered(area: AttackHitbox) -> void:
	health_component.damage(area.get_attack())
