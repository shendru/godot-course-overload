extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed = 100.0
@onready var sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
#@onready var parent_node = $Node2D
var shader_material: ShaderMaterial


signal died

var health = 2

func _ready() -> void:
	shader_material = sprite.material as ShaderMaterial
	
	
func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

	if velocity.x < 0:
		sprite.flip_h = true
		#parent_node.scale.x = -1
	elif velocity.x > 0:
		sprite.flip_h = false
		#parent_node.scale.x = 1
		
func take_damage(dmg):
	health -= dmg
	take_damage_shader()
	if health <= 0:
		#var chance = randi_range(1,2)
		#print(chance)
		#if chance == 2:
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
		die()

func die():
	died.emit()
	sprite.stop()
	if sprite.flip_h:
		animation_player.play("slime_die_right")
	else:
		animation_player.play("slime_die_left")
func take_damage_shader():
	if shader_material == null:
		return # Ensure material exists

	var tween = create_tween() # Use create_tween() on the node
	tween.tween_property(shader_material, "shader_parameter/flash_amount", 0.5, 0.04)
	tween.tween_property(shader_material, "shader_parameter/flash_amount", 1.0, 0.04)
	tween.tween_property(shader_material, "shader_parameter/flash_amount", 0.0, 0.04)
