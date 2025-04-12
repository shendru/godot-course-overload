extends Line2D

@export var length = 50
var point = Vector2()

func _process(_delta: float) -> void:
	global_position = Vector2(0,0)
	global_rotation = 0
	add_point(get_parent().global_position)
	if points.size()>length:
		remove_point(0)
