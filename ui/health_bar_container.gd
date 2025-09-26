extends Control


@export var health_bar_scene: PackedScene

var entity_to_bar := {}


func _ready():
	EventBus.health_changed.connect(_on_health_changed)
	EventBus.character_died.connect(_on_character_died)
	
func register_entity(entity: Node):
	if not entity.has_node("HealthComponent"):
		return
		
	var health_comp = entity.get_node("HealthComponent")
	var bar_instance = health_bar_scene.instantiate()
	add_child(bar_instance)
	
	entity_to_bar[entity.get_instance_id()] = bar_instance
	_on_health_changed(health_comp.current_health, health_comp.max_health, entity)
	
func _process(delta):  # TODO: rework to make hp bar follow worm
	for entity_id in entity_to_bar.keys():
		var entity: Node = instance_from_id(entity_id)
		var bar = entity_to_bar[entity_id]
		if entity and bar:
			bar.global_position = entity.global_position
				
func _on_health_changed(current: float, max: float, entity: Node):  # TODO: fix worms not taking damage
	var bar = entity_to_bar.get(entity.get_instance_id(), null)
	print("before change - bar max:", bar.max_value, " bar current:", bar.value)
	if bar:
		bar.max_value = max
		bar.value = current
		
	print("after change - bar max:", bar.max_value, " bar current:", bar.value)
	
func _on_character_died(entity: Node):
	var bar = entity_to_bar.get(entity.get_instance_id(), null)
	if bar:
		bar.queue_free()
		entity_to_bar.erase(entity)
