extends CharacterBody2D

signal died
var damage_popup_node = preload("res://scenes/damageLabel.tscn")
#var projectile_attachment = preload("res://scenes/projectile_attachment.tscn")
@onready var projectile_attachment: Node2D = $ProjectileAttachment
@onready var aggro_area: Area2D = $AggroArea


var shooter: bool = false
@onready var aim: Marker2D = %aim
@onready var aim_pos: Marker2D = %aim_pos
var weapon_knockback: float = 0


var lifetime_usage: bool = false
var self_destruct: bool = false
var self_destruct_sequence: bool = false

var direction: Vector2 = Vector2.RIGHT
var directional : bool = false
var facing: float
@export var player_reference : CharacterBody2D

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

@export var type : Enemy:
	set(value):	
		type = value
		$AnimatedSprite2D.sprite_frames = value.sprite
		$AnimatedSprite2D.scale = value.resize
		$AnimatedSprite2D.offset = value.sprite_offset
		$CollisionShape2D.shape.radius = value.collision_radius
		$CollisionShape2D.position = value.collision_position
		$AnimatedSprite2D/Shadow.position = value.shadow_position
		$AnimatedSprite2D/Shadow.scale = value.shadow_size
		movement_speed = value.movement_speed
		damage = value.damage
		health = value.health
		shooter = value.shooter
		lifetime_usage = value.lifetime_usage
		self_destruct = value.self_destruct
		$Lifetime.wait_time = value.lifetime

var elite : bool = false:
	set(value):
		elite = value
		if value:
			scale = Vector2(1.5,1.5)
			health += 30
			movement_speed += 50
			set_collision_mask_value(2,false)

func _ready() -> void:
	aim.hide()
	shader_material = sprite.material as ShaderMaterial
	shader_material.set_shader_parameter("hue_shift", type.hue_shift)
	shader_material.set_shader_parameter("saturation_boost", type.saturation_boost)
	if elite:
		shader_material.set_shader_parameter("enable_rainbow_outline", true)
	if shooter:
		#instantiate attachemtn
		#var new_attachment = projectile_attachment.instantiate()
		#new_attachment.item = load("res://Resources/weapons-experimental/enemy wand.tres")
		#add_child(new_attachment)
		projectile_attachment.item = load("res://Resources/weapons-experimental/enemy wand.tres")
		aim.show()
	#if self_destruct:
		#aggro_area.set_process_mode(Node.PROCESS_MODE_INHERIT)
	
	
func _physics_process(delta):
 
	update_facing_direction()

	knockback_update(delta)
	update_aim_rotation()
	
func knockback_update(delta):
	if not directional:
		direction = (player_reference.position - position).normalized()
	facing = sign(direction.x)
	velocity = direction * movement_speed
	
	knockback = knockback.move_toward(Vector2.ZERO, 1)
	velocity += knockback
	#move_and_collide(velocity * delta)
	var collider = move_and_collide(velocity * delta)
	if collider:
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 50

func add_knockback(amount):
	knockback += amount

func update_aim_rotation() -> void:
	if velocity.length() > 0:
		direction = velocity.normalized()
		var target_angle_radians = velocity.angle()
		aim.rotation = target_angle_radians

func update_facing_direction():
	if facing < 0:
		if flip_timer.is_stopped(): 
			sprite.scale.x = -type.resize.x
			flip_timer.start()
	elif facing > 0:
		if flip_timer.is_stopped():
			sprite.scale.x = type.resize.x
			flip_timer.start()
	

func damage_popup(amount, modifier = 1.0):
	var popup = damage_popup_node.instantiate()
	popup.text = str(int(amount * modifier))
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
		#item = load("res://Resources/pickups/Chest.tres")
		item = load("res://Resources/pickups/GemHuge.tres")
	var item_to_drop = drop.instantiate()
	
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_reference = player_reference
	get_tree().current_scene.call_deferred("add_child", item_to_drop)
	
	var additional_drop_chance = 0.1
	var additional_item = load("res://Resources/pickups/Pater.tres")
	if randf() < 0.003:
		additional_item = load("res://Resources/pickups/Vacuum.tres")
		var additional_item_to_drop = drop.instantiate()
		additional_item_to_drop.type = additional_item
		additional_item_to_drop.position = position + Vector2(10,0)
		additional_item_to_drop.player_reference = player_reference
		get_tree().current_scene.call_deferred("add_child", additional_item_to_drop)
	elif randf() < additional_drop_chance:
		var additional_item_to_drop = drop.instantiate()
		additional_item_to_drop.type = additional_item
		additional_item_to_drop.position = position + Vector2(10,0)
		additional_item_to_drop.player_reference = player_reference
		get_tree().current_scene.call_deferred("add_child", additional_item_to_drop)


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


func _on_timer_timeout() -> void:
	if not lifetime_usage:
		return
	die()



func _on_self_destruct_timeout() -> void:
	var explode_vfx = preload("res://vfx/boom_2.tscn").instantiate()
	var explode_vfx2 = preload("res://vfx/radial_echo_follow2.tscn").instantiate()
	explode_vfx.position = global_position + Vector2.UP * 50
	explode_vfx2.source = explode_vfx
	get_tree().current_scene.call_deferred("add_child",explode_vfx)
	get_tree().current_scene.call_deferred("add_child",explode_vfx2)
	await get_tree().create_timer(0.2).timeout
	queue_free()




func _on_aggro_area_body_entered(_body: Node2D) -> void:
	if self_destruct and not self_destruct_sequence:
		var self_destruct_timer = type.self_destruct_timer
		sprite.play("selfDestruct")
		animation_player.play("flash")
		var exploding_vfx = preload("res://vfx/bout_to_explode.tscn").instantiate()
		var hit_area = preload("res://scenes/hit_area_2d.tscn").instantiate()
		exploding_vfx.position += Vector2.UP * 50
		hit_area.position +=  Vector2.UP * 50
		hit_area.duration = self_destruct_timer
		call_deferred("add_child",hit_area)
		call_deferred("add_child",exploding_vfx)
		self_destruct_sequence = true
		$SelfDestruct.wait_time = self_destruct_timer
		$SelfDestruct.start()
