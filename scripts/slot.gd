extends PanelContainer

@export var item: Weapon:
	set(value):
		
		if item != null and item.has_method("reset"):
			item.reset()
		
		item = value
		$TextureRect.texture = value.icon
		$Cooldown.wait_time = value.cooldown
		item.slot = self
		print(str(item.title)+":"+str(item.level))


func _physics_process(delta: float) -> void:
	if item !=null and item.has_method("update"):
		item.update(delta)

func _on_cooldown_timeout() -> void:
	if item and owner:
		$Cooldown.wait_time = max(item.cooldown - owner.haste, 0.1)
		item.activate(owner, owner.direction, get_tree())
