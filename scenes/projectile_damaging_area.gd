extends ProjectileNode

var delay:float = 1
var counter:float = 0
@onready var collisionShape = $CollisionShape2D

func _physics_process(delta: float) -> void:
	counter += delta
	if counter > 2 * delay:
		collisionShape.disabled = false
		counter = 0
	elif counter > delay:
		collisionShape.disabled = true


func _on_lifetime_timeout() -> void:
	queue_free()
