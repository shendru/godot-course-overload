extends Node2D

var dmg: float = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.call_deferred("take_damage", dmg)

func initSomething():
	pass
