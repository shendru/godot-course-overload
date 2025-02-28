extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		#var randomDMG = randi_range(1,3)
		body.call_deferred("take_damage", 1)

func _on_timer_timeout() -> void:
		queue_free()
