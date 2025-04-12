extends Area2D

@onready var sprite: Sprite2D = $Sprite2D2

@export var max_scale:float = 0.8

@export var duration: float = 5

#@export var area_radius: float = 0.4


func _ready() -> void:
	$Sprite2D.scale = Vector2.ONE * max_scale
	$CollisionShape2D.shape.radius = max_scale * 250.0
	$CollisionShape2D.disabled = true
	tweenScale()

func animationComplete():
	$Sprite2D.texture = null
	$Sprite2D2.texture = null
	$GPUParticles2D.emitting = true
	tweenCollision()

func tweenScale():
	sprite.scale = Vector2.ZERO  # Start at 0 scale
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(max_scale,max_scale), duration) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(Callable(self, "on_tween_finished"))

func on_tween_finished():
	animationComplete()

func tweenCollision():
	var tween = create_tween()

	# Enable collision deferred (safe)
	$CollisionShape2D.set_deferred("disabled", false)

	# Keep it on for a short time
	tween.tween_interval(0.1)

	# Safely disable via a deferred method
	tween.tween_callback(Callable(self, "_disable_collision"))

	# Optional cleanup
	tween.tween_interval(0.1)
	tween.tween_callback(queue_free)

func _disable_collision():
	$CollisionShape2D.set_deferred("disabled", true)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(20)
