extends PanelContainer

@export var item: Weapon:
	set(value):
		item = value
		$TextureRect.texture = value.texture
		$Cooldown.wait_time = value.cooldown
		item.slot = self

func _on_cooldown_timeout() -> void:
	if item:
		$Cooldown.wait_time = item.cooldown
		item.activate(owner, owner.direction, get_tree())
