extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed = 100.0
@onready var sprite = $Sprite2D
@onready var shader_material = sprite.material

var health = 3 # could use a better healthbar formula

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	# Rotate the CharacterBody2D node to face the direction of movement
	if velocity.length() > 0:
		rotation = direction.angle() + PI / 2
		
func take_damage():
	
	health -= 1
	take_damage_shader()
	if health == 0:
		queue_free()
		
func take_damage_shader():
	var tween = get_tree().create_tween()
	tween.tween_property(shader_material, "shader_parameter/damage_effect", 0.5, 0.04)  # Black
	tween.tween_property(shader_material, "shader_parameter/damage_effect", 1.0, 0.04)  # White
	tween.tween_property(shader_material, "shader_parameter/damage_effect", 0.0, 0.04)  # Back to normal
