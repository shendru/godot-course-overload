extends ProjectileNode

func _on_lifetime_timeout() -> void:
	queue_free()
