extends Area2D

@onready var spawner = $"../Spawner"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/RichTextLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	$CanvasLayer/RichTextLabel.show()
	print("starting")
	$RichTextLabel.queue_free()
	$AnimationPlayer.play("start")
	spawner.set_process_mode(Node.PROCESS_MODE_INHERIT)
