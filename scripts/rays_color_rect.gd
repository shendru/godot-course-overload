extends ColorRect

var mat: ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mat = material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("seed", randf_range(0.0, 100.0))
