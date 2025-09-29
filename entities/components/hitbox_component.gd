class_name AttackHitbox
extends Area2D


var attack_damage: int = 1


func _ready() -> void:
	call_deferred("_init_attack_damage")

func _init_attack_damage() -> void:
	attack_damage = get_parent().attack_damage
	
func get_attack() -> Attack:
	var attack := Attack.new()
	attack.attack_damage = attack_damage
	return attack
