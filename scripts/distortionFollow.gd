extends ColorRect

@export var target_node : Node2D
@onready var shader_mat = material as ShaderMaterial

func _process(_delta):
	if !target_node || !get_viewport():
		return
	
	# Get camera and viewport info
	var camera = get_viewport().get_camera_2d()
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Convert world position to screen-space pixels
	var screen_pos = camera.get_screen_transform() * target_node.global_position
	#print(screen_pos)
	screen_pos *= viewport_size  # Convert to pixel coordinates
	#print(screen_pos)
	shader_mat.set_shader_parameter("target_screen_pos", screen_pos)
	
	# Progress animation (optional)
	var current_progress = shader_mat.get_shader_parameter("progress")
	shader_mat.set_shader_parameter("progress", min(current_progress + 0.01, 1.0))
