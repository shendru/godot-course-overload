extends Area2D

var direction : Vector2
var speed : float = 500
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
	if type is Vacuum:
		$Sprite2D.material = load("res://shaders/rainbowOutlineMaterial.tres")

func _on_body_entered(_body):
	type.activate()
	queue_free()

func _physics_process(delta):
	if player_reference and can_follow:
		#direction = (player_reference.position - position).normalized()
		#position += direction * speed * delta
		var target_position = player_reference.position + Vector2(0, -follow_distance) * delta
		if follow_tween and follow_tween.is_running():
			follow_tween.kill()
		follow_tween = create_tween() 
		follow_tween.tween_property(self, "position", target_position, tween_duration).set_ease(Tween.EASE_OUT)

func follow(_target : CharacterBody2D, gem_flag: bool = false):
	if type is Chest:
		return
	if gem_flag:
		if type is Gem:
			can_follow = true
	can_follow = true
