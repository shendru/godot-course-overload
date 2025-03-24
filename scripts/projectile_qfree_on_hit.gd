extends ProjectileNode

var projectile_node: PackedScene = preload("res://scenes/projectile_simple.tscn")
var splash_cone_angle: float = 360
var splashable = true

func _on_body_entered(body):
	super(body)
	if splashable:
		spawnSplash(body, 9)
	queue_free()
	
func spawnSplash(body, num_splash_projectiles):
	for i in range(num_splash_projectiles):
		var splash_projectile_instance = projectile_node.instantiate()
		splash_projectile_instance.position = global_position # Spawn at the source's global position
		splash_projectile_instance.damage = damage # Inherit damage
		splash_projectile_instance.source = source # Inherit source
		splash_projectile_instance.speed = speed # Splash projectiles have speed
		#if splash_projectile_instance.splashable:
			#splash_projectile_instance.splashable = false
		# Calculate the angle for this splash projectile
		var angle_offset = deg_to_rad((float(i) / (num_splash_projectiles - 1) - 0.5) * splash_cone_angle) if num_splash_projectiles > 1 else 0.0
		var base_direction = Vector2.RIGHT.rotated(source.aim.global_rotation) # Get the forward direction of the aim
		var splash_direction = base_direction.rotated(angle_offset)
		splash_projectile_instance.direction = splash_direction
		get_tree().current_scene.call_deferred("add_child",splash_projectile_instance)
