extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed = 100.0
@onready var sprite = $Sprite2D
@onready var shader_material = sprite.material

var health = 2 # could use a better healthbar formula

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	# Rotate the CharacterBody2D node to face the direction of movement
	if velocity.length() > 0:
		rotation = direction.angle() + PI / 2
		
func take_damage(dmg):
	health -= dmg
	take_damage_shader()
	if health <= 0:
		var chance = randi_range(1,2)
		#print(chance)
		if chance == 2:
			var new_exp = preload("res://components/exp_model.tscn").instantiate()
			#print("New EXP instance:", new_exp)
			var exp_holder = get_tree().get_root().find_child("exp_holder", true, false)
			if exp_holder:
				#print("exp holder found")
				#print("exp old loc: ", new_exp.global_position)
				new_exp.global_position = global_position
				#print("exp new loc: ", new_exp.global_position)
				exp_holder.add_child(new_exp)
			else:
				print("no exp holder")
		queue_free()
		
func take_damage_shader():
	var tween = get_tree().create_tween()
	tween.tween_property(shader_material, "shader_parameter/damage_effect", 0.5, 0.04)  # Black
	tween.tween_property(shader_material, "shader_parameter/damage_effect", 1.0, 0.04)  # White
	tween.tween_property(shader_material, "shader_parameter/damage_effect", 0.0, 0.04)  # Back to normal
