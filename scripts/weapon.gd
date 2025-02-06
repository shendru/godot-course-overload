extends Marker2D

@onready var animation = $AnimationPlayer

func _ready():
	animation.play("swing")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(0)
