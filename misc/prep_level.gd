extends Node2D

func _ready():
	await get_tree().process_frame
	Transition.fade_in(1.0)
