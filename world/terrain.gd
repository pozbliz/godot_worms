extends Node2D

@onready var level: TextureRect = $Level
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var background: TextureRect = $Background

var terrain_image: Image
var terrain_texture: ImageTexture

#func _ready():
	#terrain_image = level.texture.get_image()
	#terrain_texture = ImageTexture.create_from_image(terrain_image)
	#level.texture = terrain_texture
#
	#update_collision()
#
#func update_collision():
	#var bg_image: Image = background.texture.get_image()
	#var width = terrain_image.get_width()
	#var height = terrain_image.get_height()
	#
	#var mask = Image.create(width, height, false, Image.FORMAT_R8)
	#
	#for x in width:
		#for y in height:
			#var terrain_alpha = terrain_image.get_pixel(x, y).a
			#var bg_alpha = bg_image.get_pixel(x, y).a
			#
			#if terrain_alpha > 0 and bg_alpha > 0:
				#mask.set_pixel(x, y, Color(1, 1, 1))
			#else:
				#mask.set_pixel(x, y, Color(0, 0, 0))
				#
	#var polygon = mask_to_polygon(mask)
	#collision.polygon = polygon
	#
#func mask_to_polygon(mask: Image) -> PackedVector2Array:
	#var points = PackedVector2Array()
	#var width = mask.get_width()
	#var height = mask.get_height()
	#
	#for y in range(height):
		#for x in range(width):
			#if mask.get_pixel(x, y).r > 0:
				#if x == 0 or mask.get_pixel(x - 1, y).r == 0 or \
					#y == 0 or mask.get_pixel(x, y - 1).r == 0:
					#points.append(Vector2(x, y))
	#return points
