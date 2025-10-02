extends Node2D

var terrain_polygons : Array = []
var level_texture

func _ready() -> void:
	EventBus.explosion_triggered.connect(calculate_terrain_destruction)
	
	terrain_polygons.clear()
	var global_points = PackedVector2Array()
	for point in $CollisionPolygon2D.polygon:
		global_points.append($CollisionPolygon2D.to_global(point))
	terrain_polygons.append(global_points)
	
	level_texture = $Level.texture
	update_terrain_visual()
	
func calculate_terrain_destruction(destruction_polygon: PackedVector2Array, explosion_node: Node2D) -> void:
	var destruction_global = to_global_polygon(explosion_node, destruction_polygon)
	var new_terrain_polygons : Array = []

	# Clip each existing terrain piece against the destruction
	for terrain_polygon in terrain_polygons:
		var terrain_global = terrain_polygon
		var result = Geometry2D.clip_polygons(terrain_global, destruction_global)
		# append all resulting pieces
		for piece in result:
			new_terrain_polygons.append(piece)

	# Save the updated terrain (global polys)
	terrain_polygons = new_terrain_polygons

	# Clear old collision shapes
	for child in get_children():
		if child is CollisionPolygon2D:
			child.queue_free()

	# Create new local CollisionPolygon2D children from global polygons
	for poly in terrain_polygons:
		var local_poly = to_local_polygon(self, poly)
		var coll = CollisionPolygon2D.new()
		coll.polygon = local_poly
		add_child(coll)
		
	# rebuild projectile and visual to match collider
	update_projectile_collider()
	update_terrain_visual()
		
func update_projectile_collider() -> void:
	var collider_node = $ProjectileCollider

	for child in collider_node.get_children():
		if child is CollisionPolygon2D:
			child.queue_free()

	# create new polygons matching the terrain
	for poly in terrain_polygons:
		var local_poly = to_local_polygon(collider_node, poly)
		var coll = CollisionPolygon2D.new()
		coll.polygon = local_poly
		collider_node.add_child(coll)
		
func update_terrain_visual():
	for child in get_children():
		if child is Polygon2D:
			child.queue_free()

	# draw new polygons with texture
	for poly in terrain_polygons:
		var poly_node = Polygon2D.new()
		poly_node.polygon = to_local_polygon(self, poly)
		poly_node.texture = level_texture
		poly_node.z_index = 0
		add_child(poly_node)

# Helpers -------------------------------------------------------------------

## Converts a polygon from local coordinates to global coordinates.
func to_global_polygon(node: Node2D, poly: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for point in poly:
		out.append(node.to_global(point))
	return out

## Converts a polygon from global coordinates to the node's local coordinates.
func to_local_polygon(node: Node2D, poly: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for point in poly:
		out.append(node.to_local(point))
	return out
