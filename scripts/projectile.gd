extends Area2D
class_name ProjectileNode

var direction : Vector2 = Vector2.RIGHT
var speed : float = 200
var damage : float = 1
var knockback : float = 90
var vfx: PackedScene
var afterFx: PackedScene

var source

 
func _physics_process(delta):
	position += direction * speed * delta
 
 
func _on_body_entered(body):
	#print("some body entered")
	if body.has_method("take_damage"):
		if source and "might" in source:
			body.call_deferred("take_damage", damage * source.might)
		else:	
			body.call_deferred("take_damage", damage)
		if source:
			var knockback_direction = (body.position - source.position).normalized()
			body.knockback = knockback_direction * knockback
		else:
			body.knockback = direction * knockback
 
 
func _on_screen_exited():
	queue_free()
