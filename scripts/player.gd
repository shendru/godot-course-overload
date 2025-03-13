extends CharacterBody2D

@onready var aim = %aim
@onready var aim_pos = %aim_pos
@onready var sprite = $AnimatedSprite2D
@export var aim_offset_angle_degrees = 0
var direction: Vector2 = Vector2.RIGHT

@export var movement_speed: float = 200
var max_health : float = 10 :
	set(value):
		max_health = value
		%Health.max_value = value
		
var recovery : float = 0
var armor : float = 0		
var might : float = 1.0
var area : float = 0.0
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
		%Options.show_option()
		if level >= 2:
			%XP.max_value = 20
		elif level >= 7:
			%XP.max_value = 40

var mouse_mode: bool = false

signal exp_changed

var health: float = 10.0:
	set(value):
		health = max(value, 0)
		%Health.value = value
		if health <= 0:
			print("you dieded")
			health_depleted.emit() #does not do aynthing
	
signal health_depleted

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * movement_speed
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


func _on_magnet_area_entered(area: Area2D) -> void:
	if area.has_method("follow"):
		area.follow(self)
func gain_gold(amount):
	gold += amount

func open_chest():
	$CanvasLayer/Chest.open()


func _on_heartbeat_timeout() -> void:
	health += recovery
	print("recovering")
