extends ProjectileNode

var delay:float = 1
var counter:float = 0
@onready var collisionShape = $CollisionShape2D

func _on_body_entered(body):
	#print("some body entered")
	if body.has_method("take_damage"):
		if source and "might" in source:
			body.call_deferred("take_damage", damage * source.might)
		else:	
			body.call_deferred("take_damage", damage)
		if source:
			var knockback_direction: Vector2
			if not knockback_on_source:
				knockback_direction = (body.position - global_position).normalized()
			else:
				knockback_direction = (body.position - source.position).normalized()
			#var knockback_to_add = knockback_direction * (knockback + source.weapon_knockback)
			body.knockback = knockback_direction * (knockback + source.weapon_knockback)
			#body.add_knockback(knockback_to_add)
		else:
			body.knockback = knockback * direction


func _physics_process(delta: float) -> void:
	counter += delta
	if counter > 2 * delay:
		collisionShape.disabled = false
		counter = 0
	elif counter > delay:
		collisionShape.disabled = true


func _on_lifetime_timeout() -> void:
	queue_free()
