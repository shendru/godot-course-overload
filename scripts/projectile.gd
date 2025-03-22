extends Area2D
 
var direction : Vector2 = Vector2.RIGHT
var speed : float = 200
var damage : float = 1
var knockback : float = 90
var source

 
func _physics_process(delta):
	position += direction * speed * delta
 
 
func _on_body_entered(body):
	#print("some body entered")
	if body.has_method("take_damage"):
		if "might" in source:
			body.call_deferred("take_damage", damage * source.might)
		else:	
			body.call_deferred("take_damage", damage)
		body.knockback = direction * knockback
 
 
func _on_screen_exited():
	queue_free()
