extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("got body")
	if body.has_method("take_damage"):
		print("can damage")
		#var randomDMG = randi_range(1,3)
		body.take_damage(2)
		print("done damage")

func whip_damage_timer() -> void:
	queue_free()
	print("whip gone")
