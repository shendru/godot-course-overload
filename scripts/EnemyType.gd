extends Resource
class_name Enemy


@export var title : String
@export var sprite : SpriteFrames
@export var health : float
@export var damage : float
@export var movement_speed : float

@export var resize : Vector2
@export var sprite_offset : Vector2
@export var collision_radius : float = 9
@export var collision_position : Vector2 = Vector2(0, -9)

@export var shadow_position: Vector2
@export var shadow_size: Vector2

@export_category("Unique Modifiers")
@export var shooter: bool = false
@export var lifetime_usage: bool = false
@export var lifetime: float = 6
@export var self_destruct: bool = false
@export var self_destruct_timer: float

@export_category("Color")
@export_range(0,1) var hue_shift: float
@export_range(0,2) var saturation_boost: float = 1

@export var drops : Array[Pickups]
