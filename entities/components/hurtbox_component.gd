class_name HurtboxComponent
extends Area2D


@export var health_component: HealthComponent

var hit_attack_ids := {}


func _ready():
	area_entered.connect(_on_hurtbox_component_area_entered)
	
func _on_hurtbox_component_area_entered(area: AttackHitbox) -> void:
	var hit_id = area.get_instance_id()
	if hit_id in hit_attack_ids:
		return
		
	hit_attack_ids[hit_id] = true
	health_component.damage(area.get_attack())
	
	area.tree_exiting.connect(func():
		hit_attack_ids.erase(hit_id))
