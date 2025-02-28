extends PanelContainer
#temporary implementation

@onready var sword:PackedScene = preload("res://weapons_item/sword.tscn")
@onready var garlic:PackedScene = preload("res://weapons_item/garlic.tscn")
@onready var bible:PackedScene = preload("res://weapons_item/bible.tscn")
@onready var whip:PackedScene = preload("res://scenes/whip.tscn")

@onready var items: Node2D = %items

var sword_weap: Node2D
var garlic_weap: Node2D
var bible_weap: Node2D
var whip_weap: Marker2D

func _on_button_3_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if sword_weap == null:
			sword_weap = sword.instantiate()
			items.add_child(sword_weap)
	else:
		if sword_weap != null:
			sword_weap.queue_free()
			sword_weap = null
	


func _on_button_4_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if whip_weap == null:
			whip_weap = whip.instantiate()
			items.add_child(whip_weap)
	else:
		if whip_weap != null:
			whip_weap.queue_free()
			whip_weap = null


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if bible_weap == null:
			bible_weap = bible.instantiate()
			items.add_child(bible_weap)
	else:
		if bible_weap != null:
			bible_weap.queue_free()
			bible_weap = null


func _on_button_2_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if garlic_weap == null:
			garlic_weap = garlic.instantiate()
			items.add_child(garlic_weap)
	else:
		if garlic_weap != null:
			garlic_weap.queue_free()
			garlic_weap = null
