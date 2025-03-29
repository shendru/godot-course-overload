extends CanvasLayer

var source

func _ready() -> void:
	var mat = $ColorRect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("sprite_screen_pos", source.get_global_transform_with_canvas().origin)
	
