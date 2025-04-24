extends ProjectileNode

var projectile_nodeS: PackedScene = preload("res://scenes/projectile_disabled_vose.tscn")
var projectile_nodeC: PackedScene = preload("res://scenes/projectile_chain.tscn")


var splashable = false
var splash_count: int = 3
var splash_cone_angle: float = 75

var chainable = false
var chain_limit: int = 3
var chain_radius: int = 200

func _on_body_entered(body):
	super(body)
	if chainable:
		spawnChain(body)
	if splashable:
		spawnSplash(body, splash_count)
	queue_free()

#func remove sprite and colission set timer for q free

func spawnChain(_body):
	var new_projectile = projectile_nodeC.instantiate()
	#new_projectile.find_child("Sprite2D").texture = $Sprite2D.texture
	new_projectile.chain_limit = chain_limit
	new_projectile.chain_radius = chain_radius
	new_projectile.damage = damage
	new_projectile.position = global_position
	new_projectile.source = source
	new_projectile.speed = 0
	new_projectile.damage = damage
	get_tree().current_scene.call_deferred("add_child", new_projectile)
	#new_projectile.call_deferred("chain_to_target", body)
	
func spawnSplash(_body, num_splash_projectiles):
	for i in range(num_splash_projectiles):
		var splash_projectile_instance = projectile_nodeS.instantiate()
		splash_projectile_instance.find_child("Sprite2D").texture = $Sprite2D.texture
		splash_projectile_instance.find_child("Sprite2D").scale = Vector2(0.01,0.01)
		splash_projectile_instance.vfx = vfx
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
