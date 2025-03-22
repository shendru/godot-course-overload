extends Resource
class_name Enemy
 
@export var title : String
@export var sprite : SpriteFrames
@export var health : float
@export var damage : float
@export var movement_speed : float
@export var resize : Vector2
@export var sprite_offset : Vector2
@export var collision_radius : float
@export var collision_position : Vector2
@export var drops : Array[Pickups]
