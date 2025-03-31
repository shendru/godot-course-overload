extends TextureButton
 
 
@export var item : Item:
	set(value):
		item = value
		if value.upgrades.size() > 0 and value.upgrades.size() +1 != value.level:
			#texture_normal = value.icon
			$VBoxContainer/HBoxContainer2/TextureRect.texture = value.icon
			$VBoxContainer/HBoxContainer/Title.text = item.title
			$VBoxContainer/HBoxContainer/Lv.text = "Lvl " + str(item.level)
			$VBoxContainer/HBoxContainer2/VBoxContainer/Description.text = value.upgrades[value.level - 1].description
			$VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer3/RichTextLabel.text = value.flair
		else:
			#texture_normal = value.evolution.icon
			$VBoxContainer/HBoxContainer2/TextureRect.texture = value.evolution.icon
			$VBoxContainer/HBoxContainer/Lv.text = ""
			$VBoxContainer/HBoxContainer2/VBoxContainer/Description.text = "EVOLUTION"
 
 
func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("left_click") and item:
		print(item.title)
		get_parent().check_item(item)
		item.upgrade_item()
		get_parent().close_option()
