extends ProjectileNode

@onready var Lifetime = $Lifetime
@onready var PreLifetime = $PreLifetime

func _ready() -> void:
	PreLifetime.wait_time = Lifetime.wait_time - 1
	PreLifetime.start()

func _on_lifetime_timeout() -> void:
	queue_free()


func _on_pre_lifetime_timeout() -> void:
	$AnimationPlayer.play('fading')
	pass
