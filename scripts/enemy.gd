extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed = 100.0

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	# Rotate the CharacterBody2D node to face the direction of movement
	if velocity.length() > 0:
		rotation = direction.angle() + PI / 2
