extends Area2D

@onready var spawner = $"../Spawner"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/RichTextLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate() -> void:
	$StaticBody2D.queue_free()
	$CanvasLayer/RichTextLabel.show()
	print("starting")
	$RichTextLabel.queue_free()
	$AnimationPlayer.play("start")
	spawner.set_process_mode(Node.PROCESS_MODE_INHERIT)

func _on_body_entered(body: Node2D) -> void:
	pass
	#if body.has_method("take_damage"):
		#$StaticBody2D.queue_free()
		#$CanvasLayer/RichTextLabel.show()
		#print("starting")
		#$RichTextLabel.queue_free()
		#$AnimationPlayer.play("start")
		#spawner.set_process_mode(Node.PROCESS_MODE_INHERIT)
