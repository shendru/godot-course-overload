extends CharacterBody2D

@onready var aim = %aim
@onready var aim_pos = %aim_pos
@onready var sprite = $AnimatedSprite2D

@export var speed: float = 200

@export var aim_offset_angle_degrees = 0

@export var exp: int = 0
var base_exp: int = 100
@export var max_exp: int = base_exp
var growth_factor: float = 1.5
@export var level: int = 1

var mouseMode: bool = false

signal exp_changed

var health = 100.0
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
	if velocity.x < 0:
		sprite.flip_h = true
		#parent_node.scale.x = -1
	elif velocity.x > 0:
		sprite.flip_h = false
		#parent_node.scale.x = 1
		
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%HealthBarSquare.value = health
		if health <= 0.0:
			health_depleted.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		mouseMode = true
		#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if event.is_action_pressed("ui_cancel"):
		mouseMode = false
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func update_aim_rotation() -> void:
	if mouseMode:
		aim.look_at(get_global_mouse_position())
	else:
		if velocity.length() > 0:
			var target_angle_radians = velocity.angle()
			var aim_offset_angle_radians = deg_to_rad(aim_offset_angle_degrees)
			target_angle_radians += aim_offset_angle_radians
			# aim.rotation = lerp_angle(aim.rotation, target_angle_radians, 0.2)
			aim.rotation = target_angle_radians
			


func exp_gain() -> void:
	exp += 15
	exp_changed.emit(exp, max_exp)
	
	if exp >= max_exp:
		level_up()

func level_up() -> void:
	
	exp = exp - max_exp
	level += 1
	max_exp = base_exp * pow(level, growth_factor)
	exp_changed.emit(exp, max_exp)
	
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
