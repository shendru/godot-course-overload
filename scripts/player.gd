extends CharacterBody2D

var damage_popup_node = preload("res://scenes/damageLabel.tscn")
@onready var offset : Marker2D = %offset
@onready var eyeOffset : Marker2D = %eyeOffset
@onready var aim : Marker2D = %aim
@onready var aim_pos : Marker2D = %aim_pos
@onready var sprite = $AnimatedSprite2D
@onready var shader_material: ShaderMaterial = $AnimatedSprite2D.material as ShaderMaterial

@export var aim_offset_angle_degrees = 0

var deceleration : float = 800.0
var direction: Vector2 = Vector2.RIGHT

var growth_factor: float = 1.5
var base_exp: float = 10 #must align with %XP.max_value

#Chara stats
@export var movement_speed: float = 200
var max_health : float = 100 :
	set(value):
		max_health = value
		%Health.max_value = value
		
var recovery : float = 0
var armor : float = 0		
var might : float = 1.0
var area : float = 0.0
var haste : float = 0.0
var knockback : float = 0.0
var magnet : float = 0.0:
	set(value):
		magnet = value
		%Magnet.shape.radius = 150 + value
var growth : float = 1.0
var luck : float = 1.0
var gold : int = 0:
	set(value):
		gold = value
		%Gold.text = "Gold : " + str(value)
var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value
var total_XP : int = 0
var level: int = 1:
	set(value):
		level = value
		%Level.text = "Lvl " + str(value)
		%XP.max_value = base_exp * pow(level, growth_factor)
		#if level >= 13:
			#%XP.max_value = 1000
		#elif level >= 10:
			#%XP.max_value = 100
		#elif level >= 7:
			#%XP.max_value = 40
		#elif level >= 2:
			#%XP.max_value = 20
		%Options.show_option()

var mouse_mode: bool = false

var health: float = 100.0:
	set(value):
		health = max(value, 0)
		%Health.value = value
		if health <= 0:
			print("you dieded")
			health_depleted.emit() #does not do aynthing
	
signal health_depleted

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir != Vector2.ZERO: # Check if there's input
		velocity = input_dir * movement_speed
	else: # Decelerate
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_and_slide()
	update_aim_rotation()
	#aim.look_at(get_global_mouse_position())
	if mouse_mode:
		var mouse_position = get_global_mouse_position()
		var sprite_position = sprite.global_position

		if mouse_position.x < sprite_position.x:
			sprite.flip_h = true
		elif mouse_position.x > sprite_position.x:
			sprite.flip_h = false
	else:
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false
	update_animation()
	check_XP()
	
func update_animation():
	if velocity.length() > 0:
		if sprite.animation != "movement":
			sprite.play("movement")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		mouse_mode = true
		#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if event.is_action_pressed("ui_cancel"):
		mouse_mode = false
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("ui_accept"):
		gain_XP(11)


func update_aim_rotation() -> void:
	if mouse_mode:
		var aim_position = aim.global_position
		direction = (get_global_mouse_position() - aim_position).normalized()
		aim.look_at(get_global_mouse_position())
	else:
		if velocity.length() > 0:
			direction = velocity.normalized()
			var target_angle_radians = velocity.angle()
			var aim_offset_angle_radians = deg_to_rad(aim_offset_angle_degrees)
			target_angle_radians += aim_offset_angle_radians
			# aim.rotation = lerp_angle(aim.rotation, target_angle_radians, 0.2)
			aim.rotation = target_angle_radians
			

func take_damage(amount):
	health -= max(amount - armor, 0)
	take_damage_shader()
	damage_popup(int(amount))


func damage_popup(amount, isHeal: bool = false):
	var popup = damage_popup_node.instantiate()
	popup.text = "-"+str(amount)
	popup.position = position + Vector2(-50,-25)
	if isHeal:
		popup.text = "+"+str(amount)
		popup.scale = Vector2(0.5,0.5)
		popup.set("theme_override_colors/font_color", Color.GREEN)
	else:
		popup.set("theme_override_colors/font_color", Color.RED)
	get_tree().current_scene.add_child(popup)
	
func take_damage_shader():
	if shader_material == null:
		return # Ensure material exists

	var tween = create_tween() # Use create_tween() on the node
	tween.tween_property(shader_material, "shader_parameter/flash_amount", 0.5, 0.04)
	tween.tween_property(shader_material, "shader_parameter/flash_amount", 1.0, 0.04)
	tween.tween_property(shader_material, "shader_parameter/flash_amount", 0.0, 0.04)

	
func _on_hurt_box_body_entered(body: Node2D) -> void:
	take_damage(body.damage)


func _on_timer_timeout() -> void:
	%HurtBoxCollision.set_deferred("disabled", true)
	%HurtBoxCollision.set_deferred("disabled", false)

func gain_XP(amount):
	XP += amount * growth
	total_XP += amount * growth


func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1


func _on_magnet_area_entered(this_area: Area2D) -> void:
	if this_area.has_method("follow"):
		this_area.follow(self)
func gain_gold(amount):
	gold += amount

func open_chest():
	$CanvasLayer/Chest.open()


func _on_heartbeat_timeout() -> void:
	health += recovery
	if recovery >= 1:
		damage_popup(int(recovery), true)
	#print("recovering")
