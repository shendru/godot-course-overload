extends Area2D

var direction : Vector2
var speed : float = 300
var follow_distance : float = 0.0
var tween_duration :float = 0.2

@export var type : Pickups
@export var player_reference : CharacterBody2D:
	set(value):
		player_reference = value
		type.player_reference = value

var can_follow : bool = false
var follow_tween : Tween # Variable to store the Tween

func _ready():
	$Sprite2D.texture = type.icon
	$Sprite2D.scale = type.scale
	$Sprite2D.self_modulate = type.modulate

func _on_body_entered(_body):
	type.activate()
	queue_free()

func _physics_process(delta):
	if player_reference and can_follow:
		var target_position = player_reference.position + Vector2(0, -follow_distance)

		if follow_tween and follow_tween.is_running():
			follow_tween.kill()

		follow_tween = create_tween() 

		follow_tween.tween_property(self, "position", target_position, tween_duration).set_ease(Tween.EASE_OUT)

func follow(_target : CharacterBody2D):
	can_follow = true
