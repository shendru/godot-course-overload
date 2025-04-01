extends Line2D

@export var length = 1
var point = Vector2()
var flag: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = Vector2(0,0)
	global_rotation = 0
	add_point(get_parent().global_position)
	#global_position = Vector2(0,0)
	#global_rotation = 0
	#point = get_parent().global_position
	#add_point(point)
	if points.size()>length and flag:
		remove_point(0)


func _on_timer_2_timeout() -> void:
	flag = true
	pass # Replace with function body.
