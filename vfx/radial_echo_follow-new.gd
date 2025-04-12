extends Node2D

@onready var source
@onready var shockwave_color_rect: ColorRect = $RadialEcho/ColorRect
var camera_node: Camera2D

func _ready():
	var cameras = get_tree().get_nodes_in_group("cameras")
	if cameras.size() > 0 and cameras[0] is Camera2D:
		camera_node = cameras[0]
	else:
		for node in get_tree().get_nodes_in_group(""):
			if node is Camera2D and node.is_active():
				camera_node = node
				break

	if !is_instance_valid(camera_node):
		printerr("Error: No valid active Camera2D found.")
		set_process(false)
		return

	if !shockwave_color_rect or !(shockwave_color_rect.material is ShaderMaterial):
		printerr("Error: Shockwave ColorRect or its ShaderMaterial is missing.")
		set_process(false)
	update_shockwave_center()

func _process(_delta):
	if source and shockwave_color_rect.material is ShaderMaterial:
		update_shockwave_center()

func update_shockwave_center():
	var target_global = source.global_position
	var camera_global = camera_node.global_position
	var viewport_size = get_viewport_rect().size
	var screen_uv = (target_global - camera_global) / viewport_size + Vector2(0.5, 0.5)
	shockwave_color_rect.material.set_shader_parameter("sprite_screen_uv", screen_uv)
