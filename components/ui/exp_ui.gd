extends Control

func _ready() -> void:
	var screen_size = get_viewport_rect().size
	size.x = screen_size.x
	#size.y = screen_size.y
	position.x = -(screen_size.x / 2)
	position.y = -(screen_size.y / 2)
	#pass
	


func _on_player_exp_changed(val) -> void:
	$ProgressBar.value = val
