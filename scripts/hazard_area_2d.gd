extends Area2D

var enemy: PackedScene = preload("res://scenes/enemy.tscn")

var type: Enemy
var player_reference : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.disabled = true

func animationComplete():
	$Sprite2D.texture = null
	$Sprite2D2.texture = null
	$GPUParticles2D.emitting = true
	var enemy_instance = enemy.instantiate()
	enemy_instance.type = type
	enemy_instance.position = global_position
	enemy_instance.player_reference = player_reference
	get_tree().current_scene.add_child.call_deferred(enemy_instance)
	tweenCollision()
	
func tweenCollision():
	var tween = create_tween() # Create a tween on the current node

	# Enable collision for a short duration
	$CollisionShape2D.disabled = false
	tween.tween_interval(0.1) # Wait for 0.1 seconds (adjust as needed)

	# Disable collision again
	tween.tween_callback($CollisionShape2D.set.bind("disabled", true))

	# Optional: Add a delay before queue_free() if needed
	tween.tween_interval(0.1) # Adjust delay as needed
	tween.tween_callback(queue_free)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(20)
