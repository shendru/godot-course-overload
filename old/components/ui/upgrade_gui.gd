extends CanvasLayer

@onready var sword:PackedScene = preload("res://weapons_item/sword.tscn")
@onready var garlic:PackedScene = preload("res://weapons_item/garlic.tscn")
@onready var bible:PackedScene = preload("res://weapons_item/bible.tscn")
@onready var whip:PackedScene = preload("res://scenes/whip.tscn")
@onready var items: Node2D = get_parent().get_node("items")

func _on_texture_button_pressed() -> void:
	init_weapon(sword)
	get_tree().paused = false
	queue_free()

func _on_texture_button_2_pressed() -> void:
	init_weapon(garlic)
	get_tree().paused = false
	queue_free()

func _on_texture_button_3_pressed() -> void:
	init_weapon(bible)
	get_tree().paused = false
	queue_free()

func _on_texture_button_4_pressed() -> void:
	init_weapon(whip)
	get_tree().paused = false
	queue_free()
	
func init_weapon(weap: PackedScene):
	var new_weap = weap.instantiate()
	items.add_child(new_weap)
