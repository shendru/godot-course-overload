extends Sprite2D

var mat: ShaderMaterial

func _ready() -> void:
	mat = material as ShaderMaterial
	if mat:
		print("grass offsetted")
		mat.set_shader_parameter("offset", randf_range(0.0, 10.0))
