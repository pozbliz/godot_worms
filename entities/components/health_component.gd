class_name HealthComponent
extends Node


var current_health: float
var max_health: float


func _ready() -> void:
	max_health = get_parent().max_health
	current_health = max_health

func damage(attack: Attack):
	current_health -= attack.attack_damage
	print("taking damage: ", attack.attack_damage)
	
	if get_parent() is Character:
		get_parent().take_damage()
		EventBus.health_changed.emit(current_health, max_health, get_parent())
	
	if current_health <= 0:
		await get_parent().die()
