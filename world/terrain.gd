extends Node2D

var terrain_polygons : Array = []

func _ready() -> void:
	EventBus.explosion_triggered.connect(calculate_terrain_destruction)
	
	terrain_polygons.clear()
	var g = PackedVector2Array()
	for p in $CollisionPolygon2D.polygon:
		g.append($CollisionPolygon2D.to_global(p))
	terrain_polygons.append(g)
	
func calculate_terrain_destruction(destruction_polygon: PackedVector2Array, explosion_node: Node2D) -> void:
	var destruction_global = to_global_polygon(explosion_node, destruction_polygon)
	var new_terrain_polygons : Array = []

	# Clip each existing terrain piece against the destruction
	for t_poly in terrain_polygons:
		var t_global = t_poly
		var result = Geometry2D.clip_polygons(t_global, destruction_global) # returns Array of polygons
		# append all resulting pieces
		for piece in result:
			new_terrain_polygons.append(piece)

	# Save the updated terrain (global polys)
	terrain_polygons = new_terrain_polygons

	# Rebuild collision shapes under StaticBody2D (clear old ones)
	for child in get_children():
		if child is CollisionPolygon2D:
			child.queue_free()

	# Create new CollisionPolygon2D children from global polygons
	for poly in terrain_polygons:
		# convert to local coordinates of the StaticBody2D (so the CollisionPolygon2D polygon is correct)
		var local_poly = to_local_polygon(self, poly)
		var coll = CollisionPolygon2D.new()
		coll.polygon = local_poly
		add_child(coll)

# Helpers -------------------------------------------------------------------

func to_global_polygon(node: Node2D, poly: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in poly:
		out.append(node.to_global(p))
	return out

func to_local_polygon(node: Node2D, poly: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in poly:
		out.append(node.to_local(p))
	return out
