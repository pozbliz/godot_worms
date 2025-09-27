class_name AttackHitbox
extends Area2D


var attack_damage: int = 1


func _ready() -> void:
	attack_damage = get_parent().attack_damage
	
func get_attack() -> Attack:
	var attack := Attack.new()
	attack.attack_damage = attack_damage
	print("attacking for: ", attack.attack_damage)
	return attack
