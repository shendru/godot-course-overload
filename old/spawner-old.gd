extends Path2D

@onready var line_2d = %spawnLine  # Ensure Line2D is inside Path2D

func _ready():
	adjust_path_to_screen()
	update_line2d()

func adjust_path_to_screen():
	var screen_size = get_viewport_rect().size  # Get screen dimensions
	position.x = -(screen_size.x / 2)
	position.y = -(screen_size.y / 2)
	curve.clear_points()  # Clear existing curve points

	# Define new points for a rectangle covering the screen
	curve.add_point(Vector2(0, 0))  # Top-left
	curve.add_point(Vector2(screen_size.x, 0))  # Top-right
	curve.add_point(Vector2(screen_size.x, screen_size.y))  # Bottom-right
	curve.add_point(Vector2(0, screen_size.y))  # Bottom-left
	curve.add_point(Vector2(0, 0))  # Close the shape

	print("Path2D resized to screen:", screen_size)

func update_line2d():
	if not curve:
		print("No curve found!")
		return
	
	var points = []
	for i in range(curve.get_point_count()):
		points.append(curve.get_point_position(i))
	
	if line_2d:
		line_2d.points = points  # Apply points to Line2D
		line_2d.queue_redraw()  # Force visual update
		print("Updated Line2D with", len(points), "points")
	else:
		print("Line2D node not found!")
