extends Marker2D

@onready var animation = $AnimationPlayer

func _ready():
	animation.play("swing")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
