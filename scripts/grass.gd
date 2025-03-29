extends Area2D

@export var min_skew: float = -5000.0
@export var max_skew: float = 5000.0
@onready var sprite = $Sprite2D
var mat: ShaderMaterial

func _ready() -> void:
	mat = sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("offset", randf_range(0.0, 10.0))

func apply_sway(effect_source: Node2D) -> void:
	var direction = global_position.direction_to(effect_source.global_position)
	var shader_skew = clamp(remap(200 * sign(-direction.x), -200, 200, min_skew, max_skew), min_skew, max_skew)

	if not sprite or not sprite.material or not sprite.material is ShaderMaterial:
		push_warning("ShaderMaterial not found on Sprite2D.")
		return

	var tween = create_tween()
	if tween:
		tween.tween_property(mat, "shader_parameter/skew", shader_skew, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(mat, "shader_parameter/skew", 0.0, 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	else:
		push_warning("Tween creation failed.")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_real_velocity"):
		apply_sway(body)

func _on_area_entered(area: Area2D) -> void:
	apply_sway(area)
