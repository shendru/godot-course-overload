extends ProjectileNode

var max_distance: float = 2000.0
var source_position: Vector2

@export var radius: float = 100.0
@export var angular_speed: float = 1.0


var angle: float = 0.0
var initial_angle: float = 0

var phase0Flag: bool = true
var target_direction: Vector2 = Vector2.ZERO  # Direction to move in phase 1
var is_rotating: bool = false  # Prevents movement during rotation




func _ready() -> void:
	super()
	source_position = position
	knockback_on_source = true

func _physics_process(delta: float) -> void:
	if source and phase0Flag:
		angle -= angular_speed * delta
		var orbit_angle = initial_angle + angle  # Maintain offset from spawn angle
		global_position = source.global_position + Vector2(cos(orbit_angle), sin(orbit_angle)) * radius
		#rotation = orbit_angle  # Adjust rotation to face outward
		rotation = PI / 2
	elif not phase0Flag and not is_rotating:
		# Move towards the target after rotation is complete
		global_position += target_direction * speed * delta

func _process(_delta):
	if global_position.distance_to(source_position) > max_distance:
		print("a projectile was freed")
		queue_free()
		
func _on_screen_exited():
	pass
	
func _on_phase_1_timeout() -> void:
	
	
	phase0Flag = false
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.is_empty():
		queue_free()
		return	

	# Pick a random enemy
	var enemy = enemies.pick_random()
	var enemy_position = enemy.global_position

	# Compute direction to face the enemy
	target_direction = (enemy_position - global_position).normalized()

	# Rotate the projectile towards the enemy using Tween
	var tween = get_tree().create_tween()
	var target_angle = global_position.angle_to_point(enemy_position)
	is_rotating = true  # Disable movement while rotating
	
	tween.tween_property(self, "rotation", target_angle, 1)  # Rotate over 0.3s
	tween.tween_callback(func(): start_moving())  # Call function after tween
	


func start_moving() -> void:
	is_rotating = false  # Allow movement after rotation is complete
