extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed: float = 200  # Speed at which the Area2D moves
var enabled = false
var velocity = Vector2.ZERO  # Initial velocity is zero

func get_looted():
	if not enabled:
		enabled = true

func _process(delta):
	if enabled:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		position += velocity * delta
		if position.distance_to(player.position) < 5:  # Threshold of 10 pixels (you can adjust)
			if player.has_method("exp_gain"):
				player.exp_gain()
				queue_free()

func _on_area_entered(area: Area2D) -> void:
	print("entered body")
	if not enabled and area.name == "Looter":
		print("found looter")
		enabled = true
