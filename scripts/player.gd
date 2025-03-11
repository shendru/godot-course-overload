extends CharacterBody2D

@onready var aim = %aim
@onready var aim_pos = %aim_pos
@onready var sprite = $AnimatedSprite2D
@export var aim_offset_angle_degrees = 0

@export var speed: float = 200
var direction: Vector2 = Vector2.RIGHT

@export var curr_exp: float = 0
var base_exp: float = 100.0
@export var max_exp: float = base_exp
var growth_factor: float = 1.5
@export var level: int = 1

var mouse_mode: bool = false

signal exp_changed

var health: float = 100.0:
	set(value):
		health = value
		%HealthBarSquare.value = value
	
signal health_depleted

#func _ready() -> void:
##	FORMULA FOR THE EXP
	#pass


func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed
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
		
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		mouse_mode = true
		#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if event.is_action_pressed("ui_cancel"):
		mouse_mode = false
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


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
			


func exp_gain() -> void:
	curr_exp += 15
	exp_changed.emit(curr_exp, max_exp)
	
	if curr_exp >= max_exp:
		level_up()

func level_up() -> void:
	
	curr_exp = curr_exp - max_exp
	level += 1
	max_exp = base_exp * pow(level, growth_factor)
	exp_changed.emit(curr_exp, max_exp)
	
	var upgrade_ui = preload("res://components/ui/upgrade_gui.tscn").instantiate()
	add_child(upgrade_ui)
	
	get_tree().paused = true
	pass

func calculate_exp() -> void:
	pass

func _on_looter_area_entered(area: Area2D) -> void:
	if area.name == "Exp":
		if area.has_method("get_looted"):
			area.get_looted()
		print("found exp")

func take_damage(amount):
	health -= amount

func _on_hurt_box_body_entered(body: Node2D) -> void:
	take_damage(body.damage)


func _on_timer_timeout() -> void:
	%HurtBoxCollision.set_deferred("disabled", true)
	%HurtBoxCollision.set_deferred("disabled", false)
