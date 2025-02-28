extends Node2D

@onready var testNode = %Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		toggleVisibility()
		
func toggleVisibility():
	testNode.visible = !testNode.visible
	
