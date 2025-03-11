extends Area2D
 
var direction : Vector2 = Vector2.RIGHT
var speed : float = 200
var damage : float = 1
 
func _physics_process(delta):
	position += direction * speed * delta
 
 
func _on_body_entered(body):
	print("some body entered")
	if body.has_method("take_damage"):
		body.call_deferred("take_damage", damage)
		body.knockback = direction * 90
 
 
func _on_screen_exited():
	queue_free()
