extends Resource
class_name Grass

@export var title : String
@export var sprite : Texture2D
@export var health : float
@export var resize : Vector2
@export var sprite_offset : Vector2
@export_range(0,1) var shader_height_offset: float
#@export var collision_radius : float
#@export var collision_position : Vector2
@export var drops : Array[Pickups]
