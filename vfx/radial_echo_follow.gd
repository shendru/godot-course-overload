extends CanvasLayer


var source


func _ready() -> void:

	var mat = $ColorRect.material as ShaderMaterial

	if mat:

		_update_shader_position() # Initial update


	# Connect to the viewport's resized signal

	if get_viewport().is_connected("size_changed", Callable(self, "_on_viewport_resized")):

		get_viewport().disconnect("size_changed", Callable(self, "_on_viewport_resized"))

	get_viewport().connect("size_changed", Callable(self, "_on_viewport_resized"))


func _process(_delta: float) -> void:

	# You might want to update the position every frame if the source moves

	if is_instance_valid(source):

		_update_shader_position()


func _update_shader_position() -> void:

	var mat = $ColorRect.material as ShaderMaterial

	if mat and is_instance_valid(source):

		mat.set_shader_parameter("sprite_screen_pos", source.get_global_transform_with_canvas().origin)


func _on_viewport_resized() -> void:

	_update_shader_position() 
