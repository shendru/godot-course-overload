extends Node2D

var enemy: PackedScene = preload("res://scenes/enemy_event_type.tscn")

var type: Enemy
var player_reference : CharacterBody2D
var direction = Vector2.RIGHT
#var lifetime = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func animationComplete():
	$Sprite2D.texture = null
	$Sprite2D2.texture = null
	#$GPUParticles2D.emitting = true
	var enemy_instance = enemy.instantiate()
	
	enemy_instance.directional = true
	
	enemy_instance.type = type
	enemy_instance.position = global_position
	enemy_instance.direction = direction
	enemy_instance.player_reference = player_reference
	#if enemy_instance.has_node("Lifetime"):
		#enemy_instance.get_node("Lifetime").wait_time = max(lifetime,0.1)
	get_tree().current_scene.add_child.call_deferred(enemy_instance)
	#tweenCollision()
	
#func tweenCollision():
	#var tween = create_tween() # Create a tween on the current node
#
	## Enable collision for a short duration
	#$CollisionShape2D.disabled = false
	#tween.tween_interval(0.1) # Wait for 0.1 seconds (adjust as needed)
#
	## Disable collision again
	#tween.tween_callback($CollisionShape2D.set.bind("disabled", true))
#
	## Optional: Add a delay before queue_free() if needed
	#tween.tween_interval(0.1) # Adjust delay as needed
	#tween.tween_callback(queue_free)


func _on_timer_timeout() -> void:
	queue_free()
