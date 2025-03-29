extends Node2D


func _on_projectile_static_field_area_entered(area: Area2D) -> void:
	if area.has_method("extra_condition"):
		#print("area has extra condition")
		area.extra_condition()
