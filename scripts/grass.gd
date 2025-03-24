extends Area2D

@export var min_skew: float = -5000.0
@export var max_skew: float = 5000.0
@onready var sprite = $Sprite2D
var mat: ShaderMaterial

func _ready() -> void:
	mat = sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("offset", randf_range(0.0, 10.0))

func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("get_real_velocity"):
		#print("body has no get real velocity")
		return
	#print("body has real velocity")
	var direction = global_position.direction_to(body.global_position)
	#var velocity = body.get_real_velocity().length()  # Use body's velocity
	#var skew = clamp(remap(velocity * sign(-direction.x), -body.movement_speed, body.movement_speed, min_skew, max_skew), min_skew, max_skew)
	var shader_skew = clamp(remap(200 * sign(-direction.x), -200, 200, min_skew, max_skew), min_skew, max_skew)

	
	if not sprite or not sprite.material or not sprite.material is ShaderMaterial:
		push_warning("ShaderMaterial not found on AnimatedSprite2D.")
		return
	
	var tween = create_tween()
	if tween:
		tween.tween_property(mat, "shader_parameter/skew", shader_skew, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(mat, "shader_parameter/skew", 0.0, 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	else:
		push_warning("Tween creation failed.")
