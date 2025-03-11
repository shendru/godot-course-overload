extends CharacterBody2D

var player_reference : CharacterBody2D
var damage_popup_node = preload("res://scenes/damageLabel.tscn")


@onready var sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
var shader_material: ShaderMaterial

var knockback: Vector2
@export var speed: float = 100.0
var damage: float
var health: float
var elite : bool = false:
	set(value):
		elite = value
		if value:
			scale = Vector2(1.5,1.5)

var type : Enemy:
	set(value):	
		type = value
		$AnimatedSprite2D.sprite_frames = value.sprite
		$AnimatedSprite2D.scale = value.resize
		damage = value.damage
		health = value.health

signal died

func _ready() -> void:
	shader_material = sprite.material as ShaderMaterial
	
	
func _physics_process(delta):
 
	if velocity.x < 0:
		sprite.flip_h = true
		#parent_node.scale.x = -1
	elif velocity.x > 0:
		sprite.flip_h = false
		#parent_node.scale.x = 1
	knockback_update(delta)
		
func knockback_update(delta):
	velocity = (player_reference.position - position).normalized() * speed
	knockback = knockback.move_toward(Vector2.ZERO, 1)
	velocity += knockback
	var collider = move_and_collide(velocity * delta)
	if collider:
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 50

func damage_popup(amount):
	var popup = damage_popup_node.instantiate()
	popup.text = str(amount)
	popup.position = position + Vector2(-50,-50)
	get_tree().current_scene.add_child(popup)
	
func take_damage(dmg):
	damage_popup(int(dmg))
	health -= dmg
	take_damage_shader()
	if health <= 0:
		#var chance = randi_range(1,2)
		#print(chawaance)
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
