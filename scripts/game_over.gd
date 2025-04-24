extends NinePatchRect


func _ready() -> void:
	hide()



func _on_retry_pressed() -> void:

	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/character_selection.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_player_health_depleted() -> void:
	$AnimationPlayer.play("gameOverFade")
