extends CharacterBody2D

signal died

var player_reference : CharacterBody2D
var damage_popup_node = preload("res://scenes/damageLabel.tscn")
@onready var flip_timer : Timer = $flipTimer

@onready var sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
var shader_material: ShaderMaterial

var knockback: Vector2
@export var movement_speed: float = 100.0
var damage: float
var is_dead = false

var drop = preload("res://scenes/pickups.tscn")

var health: float:
	set(value):
		health = value
		if health <= 0 and not is_dead: # Added check
			is_dead = true # Set the flag
			drop_item()
			die()
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
		$AnimatedSprite2D.offset = value.sprite_offset
		$CollisionShape2D.shape.radius = value.collision_radius
		$CollisionShape2D.position = value.collision_position
		movement_speed = value.movement_speed
		damage = value.damage
		health = value.health



func _ready() -> void:
	shader_material = sprite.material as ShaderMaterial
	
	
func _physics_process(delta):
 
	if velocity.x < 0:
		if flip_timer.is_stopped(): 
			sprite.scale.x = -type.resize.x
			flip_timer.start() 
	elif velocity.x > 0:
		if flip_timer.is_stopped():
			sprite.scale.x = type.resize.x
			flip_timer.start()

	knockback_update(delta)
		
func knockback_update(delta):
	velocity = (player_reference.position - position).normalized() * movement_speed
	knockback = knockback.move_toward(Vector2.ZERO, 1)
	velocity += knockback
	var collider = move_and_collide(velocity * delta)
	if collider:
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 50

func damage_popup(amount, modifier = 1.0):
	var popup = damage_popup_node.instantiate()
	popup.text = str(amount * modifier)
	popup.position = position + Vector2(-50,-50)
	if modifier > 1.0:
		popup.set("theme_override_colors/font_color", Color.ORANGE_RED)
	get_tree().current_scene.add_child(popup)
	
func take_damage(dmg):
	
	take_damage_shader()
	var chance = randf()
	var modifier : float = 2.0 if (chance< (1.0 - (1.0/player_reference.luck))) else 1.0
	damage_popup(dmg, modifier)
	health -= dmg * modifier

func drop_item():
	#print("dropping gem")
	if type.drops.size() == 0:
		print("no enemy drops")
		return
	var item = type.drops.pick_random()
	if elite:
		item = load("res://Resources/pickups/Chest.tres")
	var item_to_drop = drop.instantiate()
	
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_reference = player_reference
	get_tree().current_scene.call_deferred("add_child", item_to_drop)

func die():
	died.emit()
	sprite.stop()
	if sprite.scale.x < 0:
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
