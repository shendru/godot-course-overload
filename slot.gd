extends PanelContainer

@export var weapon: Weapon:
	set(value):
		weapon = value
		$TextureRect.texture = value.texture
		$Cooldown.wait_time = value.cooldown


func _on_cooldown_timeout() -> void:
	if weapon:
		$Cooldown.wait_time = weapon.cooldown
		weapon.activate(owner.aim_pos.global_position, owner.direction, get_tree())
