extends Weapon
class_name SlamAndSplash

@export var num_splash_projectiles : int = 5
@export var splash_projectile_node : PackedScene = preload("res://scenes/projectile.tscn")
@export var splash_cone_angle : float = 90.0 # Angle in degrees for the cone of splash projectiles
@export var splash_travel_distance : float = 150.0
@export var main_weapon_lifetime : float = 0.5
@export var splash_projectile_lifetime : float = 1.0

func activate(source, _target, scene_tree):
	# Instantiate the main weapon as a child of the source
	var main_weapon_instance = projectile_node.instantiate()
	#main_weapon_instance.position = source.aim_pos.position
	main_weapon_instance.rotation = source.aim.rotation # Copy rotation from source's aim
	main_weapon_instance.speed = 0 # Main weapon has no speed
	main_weapon_instance.damage = damage # Inherit damage
	main_weapon_instance.source = source # Inherit source
	main_weapon_instance.scale = Vector2(2.0,2.0)
	var timer = main_weapon_instance.find_child("Lifetime")
	timer.wait_time = main_weapon_lifetime
	if texture != null:
		main_weapon_instance.find_child("Sprite2D").texture = texture
	source.offset.add_child(main_weapon_instance)
	#if timer:
		##print("timer exists")
		#timer.start()

	# Wait for the main weapon's lifetime and then free it
	#await scene_tree.create_timer(main_weapon_lifetime).timeout
	#if is_instance_valid(main_weapon_instance):
		#main_weapon_instance.queue_free()

	# Instantiate and launch the splash projectiles
	for i in range(num_splash_projectiles):
		var splash_projectile_instance = splash_projectile_node.instantiate()
		splash_projectile_instance.position = source.global_position # Spawn at the source's global position
		splash_projectile_instance.damage = damage # Inherit damage
		splash_projectile_instance.source = source # Inherit source
		splash_projectile_instance.speed = speed # Splash projectiles have speed

		# Calculate the angle for this splash projectile
		var angle_offset = deg_to_rad((float(i) / (num_splash_projectiles - 1) - 0.5) * splash_cone_angle) if num_splash_projectiles > 1 else 0.0
		var base_direction = Vector2.RIGHT.rotated(source.aim.global_rotation) # Get the forward direction of the aim
		var splash_direction = base_direction.rotated(angle_offset)
		splash_projectile_instance.direction = splash_direction

		scene_tree.current_scene.add_child(splash_projectile_instance)

		# We might need a way to stop the projectile after traveling a certain distance.
		# One way is to calculate a target position and move towards it.
		#var target_position = source.global_position + splash_direction * splash_travel_distance
		# You might need to implement logic in the splash projectile's script to move towards this target
		# or handle its lifetime and stopping behavior there.
#
		## For now, let's just make them free after their lifetime
		#await scene_tree.create_timer(splash_projectile_lifetime).timeout
		#if is_instance_valid(splash_projectile_instance):
			#splash_projectile_instance.queue_free()

func upgrade_item():
	if max_level_reached():
		slot.item = evolution
		return

	if not is_upgradable():
		return

	var upgrade = upgrades[level - 1]
	damage += upgrade.damage
	cooldown += upgrade.cooldown
	speed += upgrade.speed # This will affect the splash projectile speed
	num_splash_projectiles += upgrade.amount # Assuming 'amount' in upgrades refers to the number of splash projectiles
	splash_cone_angle += upgrade.area # Assuming 'area' in upgrades can affect the cone angle
	splash_travel_distance += upgrade.speed # Could use a different upgrade property if needed
	main_weapon_lifetime += upgrade.cooldown # Could use a different upgrade property if needed
	splash_projectile_lifetime += upgrade.cooldown # Could use a different upgrade property if needed
	level += 1

func reset():
	# We might need to keep track of instantiated main weapons and splash projectiles to properly reset them if needed.
	# For now, the automatic freeing after lifetime should handle it.
	pass
