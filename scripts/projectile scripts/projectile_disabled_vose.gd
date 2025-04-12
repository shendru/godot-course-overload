extends ProjectileNode

var max_distance: float = 6000.0  # Adjust as needed
var source_position: Vector2  # Set this when spawning


#var projectile_node: PackedScene = preload("res://scenes/projectile_simple.tscn")
var projectile_node: PackedScene = preload("res://scenes/projectile_chain.tscn")
var splash_cone_angle: float = 360
var splashable = false
var chainable = false

func _ready() -> void:
	super()
	source_position = position

func _process(_delta):
	if global_position.distance_to(source_position) > max_distance:
		print("a projectile was freed")
		queue_free()
		
func _on_screen_exited():
	pass



func _on_body_entered(body):
	super(body)
	if chainable:
		spawnChain(body)
	if splashable:
		spawnSplash(body, 9)

func spawnChain(_body):
	var new_projectile = projectile_node.instantiate()
	new_projectile.chain_limit = 5
	new_projectile.damage = damage
	new_projectile.position = global_position
	new_projectile.source = source
	new_projectile.speed = 0
	get_tree().current_scene.call_deferred("add_child", new_projectile)
	new_projectile.call_deferred("chain_to_target")
	
func spawnSplash(_body, num_splash_projectiles):
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
