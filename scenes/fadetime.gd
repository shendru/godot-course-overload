extends Timer

func _ready() -> void:
	wait_time = $"../Lifetime".wait_time - 2


func _on_timeout() -> void:
	$"../AnimationPlayer".play("fading")
