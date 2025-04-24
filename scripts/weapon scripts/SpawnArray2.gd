extends Weapon
class_name SpawnArray2

@export var lifetime: float = 1
@export var area: float = 1
@export var mult_collision_shape: float = 0
## Collision on and off interval delay
@export var delay: float = 0.2
@export var spawn_once: bool = true
@export var knockback: float = 90

@export var amount: int = 1
@export var angular_speed = 20
var angle:float = 0
var target_direction: Vector2 = Vector2.ZERO
var counter: float = 0
var flag:bool = true

#@export_group("Self Free Explode")
#@export var has_pre_lifetime: bool = false
#@export var pre_lifetime:float = 0


var projectile_reference = []
var source_reference
var scene_tree_reference

func spawn(source, _target, scene_tree):
	if projectile_reference.size()>=1 and spawn_once:
		return
	counter = 0
	flag = true
	for i in range(amount):
		var projectile = projectile_node.instantiate()
		if projectile.has_node("Lifetime"):
			projectile.get_node("Lifetime").wait_time = lifetime
		if "delay" in projectile:
			projectile.delay = delay
		
		source_reference = source
		scene_tree_reference = scene_tree
		
		projectile.damage = damage
		projectile.speed = 0
		projectile.source = source
		projectile.scale = Vector2(area,area)
		projectile.knockback = knockback
		
		
		var offset = -i * (360.0/amount)
		projectile.position = source.position + 100 * Vector2(cos(deg_to_rad(offset)), sin(deg_to_rad(offset)))
		projectile.hide()
		#projectile.initial_angle = deg_to_rad(offset)
		#projectile.rotation = deg_to_rad(offset)
		
		if mult_collision_shape > 0:
			projectile.mult_collision_shape = mult_collision_shape
		if texture != null:
			projectile.find_child("Sprite2D").texture = texture
		if rescale != 0:
			projectile.find_child("Sprite2D").scale = Vector2(rescale,rescale)
		
		if vfx != null:
			#var new_vfx = vfx.instantiate()
			#new_vfx.source = projectile
			projectile.vfx = vfx
			if afterFx !=null:
				projectile.afterFx = afterFx
			#projectile.add_child(new_vfx)
			if afterFxMAX != null and "afterFxMAX" in projectile and max_level_reached():
				projectile.afterFxMAX = afterFxMAX
		scene_tree.current_scene.add_child(projectile)
		
		await scene_tree.create_timer(0.1).timeout
		#projectile.tree_exited.connect(Callable(self, "_on_tree_exitted").bind(projectile))
		projectile_reference.append(projectile)

func update(delta):
	counter += delta
	#print(counter)
	if counter <= 3:  # Equivalent to timeout
		angle -= angular_speed * delta
		for i in range(projectile_reference.size()):
			var offset = -i * (360.0 / amount)
			projectile_reference[i].position = source_reference.position + 100 * Vector2(cos(deg_to_rad(angle + offset)), sin(deg_to_rad(angle + offset)))
			projectile_reference[i].rotation = deg_to_rad(angle + offset)
			projectile_reference[i].show()
	elif counter >=3 and flag:
		#print("Throw projetiles?")
		flag = false
		var enemies = scene_tree_reference.get_nodes_in_group("Enemy")
		if enemies.is_empty():
			print("enemy is empty")
			return	

		for i in range(projectile_reference.size()):
			# Pick a random enemy
			var enemy = enemies.pick_random()
			if enemy:
				var enemy_position = enemy.global_position
				

				# Compute direction to face the enemy
				var target_direction = (enemy_position - projectile_reference[i].position).normalized()

				# Rotate the projectile towards the enemy using Tween
				var tween = scene_tree_reference.create_tween()
				var target_angle = projectile_reference[i].position.angle_to_point(enemy_position)
				
				tween.tween_property(projectile_reference[i], "rotation", target_angle, 1)
				
				# After tween completes, launch the projectile
				tween.finished.connect(_on_tween_completed.bind(projectile_reference[i], target_direction))
				await scene_tree_reference.create_timer(0.1).timeout
			else:
				projectile_reference[i].queue_free()
				
		projectile_reference.clear()
		print("Size:"+str(projectile_reference.size()))

func _on_tween_completed(projectile, direction):
	projectile.speed = speed
	projectile.direction = direction

	


##region
#angle -= angular_speed * delta
		#var orbit_angle = initial_angle + angle  # Maintain offset from spawn angle
		#global_position = source.global_position + Vector2(cos(orbit_angle), sin(orbit_angle)) * radius
		##rotation = orbit_angle  # Adjust rotation to face outward
		#rotation = PI / 2
##endregion


func _on_tree_exitted(projectile):
	if is_instance_valid(projectile):
		print("cleaned up spawn Array")
		print("Size: "+str(projectile_reference.size()))
		projectile_reference.erase(projectile)
	


func activate(source, target, scene_tree):
	spawn(source, target, scene_tree)

func upgrade_item():
	if max_level_reached():
		slot.item = evolution
		return
	
	if not is_upgradable():
		return
	
	var upgrade = upgrades[level - 1]
	damage += upgrade.damage
	cooldown += upgrade.cooldown
	speed += upgrade.speed
	
	lifetime += upgrade.lifetime
	area += upgrade.area
	delay += upgrade.delay
	knockback += upgrade.knockback
	
	level += 1
