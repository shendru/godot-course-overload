extends CharacterBody2D

@onready var marker = %aim
@onready var marker_pos = %aim_pos

@export var speed: float = 200.0
@export var marker_offset_angle_degrees = 90.0

@export var exp: int = 0
@export var base_max_exp: int = 100
@export var level: int = 1
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
	update_marker_rotation()
	
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			health_depleted.emit()

func update_marker_rotation():
	if velocity.length() > 0:
		var target_angle_radians = velocity.angle()
		var marker_offset_angle_radians = deg_to_rad(marker_offset_angle_degrees)
		target_angle_radians += marker_offset_angle_radians
		# marker.rotation = lerp_angle(marker.rotation, target_angle_radians, 0.2)
		marker.rotation = target_angle_radians
		
#func attack():
	#const WEAP = preload("res://scenes/weapon.tscn")
	#var new_attack = WEAP.instantiate()
	#new_attack.rotation = marker.rotation
	##new_attack.position = marker_pos.position
	#%attacks.add_child(new_attack)
#
#
#func _on_timer_timeout() -> void:
	#attack()

func exp_gain() -> void:
	exp += 15
	exp_changed.emit(exp)

func calculate_exp() -> void:
	pass

func _on_looter_area_entered(area: Area2D) -> void:
	if area.name == "Exp":
		if area.has_method("get_looted"):
			area.get_looted()
		print("found exp")
