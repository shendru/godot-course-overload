extends TextureButton
 
 
@export var item : Item:
	set(value):
		item = value
		if value.upgrades.size() > 0 and value.upgrades.size() +1 != value.level:
			texture_normal = value.icon
			$Label.text = "Lvl " + str(item.level + 1)
			$Description.text = value.upgrades[value.level - 1].description
		else:
			texture_normal = value.evolution.icon
			$Label.text = ""
			$Description.text = "EVOLUTION"
 
 
func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("left_click") and item:
		print(item.title)
		get_parent().check_item(item)
		item.upgrade_item()
		get_parent().close_option()
