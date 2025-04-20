extends RichTextLabel
 
func _ready():
	popp()
 
func popp():
	var tween = get_tree().create_tween()
	var initial_position = position

	var target_position = initial_position + Vector2(0, -20) 

	tween.tween_property(self, "scale", Vector2(2, 2), 0.1)
	tween.tween_property(self, "position", target_position, 0.1)

	tween.chain().tween_property(self, "scale", Vector2(1, 1), 0.2)
	tween.tween_property(self, "position", initial_position, 0.2)

	await tween.finished
	queue_free()
