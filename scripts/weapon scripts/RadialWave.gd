extends Weapon
class_name RadialWave

@export var lifetime : float = 1.0
@export var knockback : float = 50
@export var scaling_speed : float = 5.0
@export var add_on_source : bool = false


var active_waves = []

func activate(source, _target, scene_tree):
	print("number of active waves: "+str(active_waves.size()))
	var projectile = projectile_node.instantiate()
	projectile.position = source.position
	projectile.damage = damage
	projectile.source = source
	projectile.speed = 0
	projectile.knockback = knockback
	if projectile.has_node("Lifetime"):
		var timer = projectile.get_node("Lifetime")
		timer.wait_time = lifetime
		timer.timeout.connect(Callable(self, "_on_wave_timeout").bind(projectile))
		
	projectile.scale = Vector2.ZERO # Start with zero scale
	
	if texture != null:
		if projectile.has_node("Sprite2D"):
			projectile.get_node("Sprite2D").texture = texture
	
	if add_on_source:
		projectile.position = Vector2.ZERO
		source.offset.add_child(projectile)
	else:
		scene_tree.current_scene.add_child(projectile)
	
	if vfx !=null:
		#print("vfx is not null for radialWave")
		var new_vfx = vfx.instantiate()
		#scene_tree.current_scene.add_child(new_vfx)
		projectile.add_child(new_vfx)
	active_waves.append(projectile)

	## Create a timer for this specific projectile's lifetime
	#var timer = Timer.new()
	#projectile.add_child(timer)
	#timer.wait_time = lifetime
	#timer.one_shot = true
	#timer.timeout.connect(Callable(self, "_on_wave_timeout").bind(projectile))
	#timer.start()

func _on_wave_timeout(wave):
	if is_instance_valid(wave):
		print("wave erased")
		wave.queue_free()
		active_waves.erase(wave)

func update(delta):
	for wave in active_waves:
		if is_instance_valid(wave):
			wave.scale += Vector2.ONE * scaling_speed * delta

func upgrade_item():
	if max_level_reached():
		slot.item = evolution
		return

	if not is_upgradable():
		return

	var upgrade = upgrades[level - 1]
	damage += upgrade.damage
	cooldown += upgrade.cooldown
	lifetime += upgrade.lifetime
	knockback += upgrade.knockback
	#scaling_speed += upgrade.scaling_speed
	level += 1

func reset():
	for wave in active_waves:
		if is_instance_valid(wave):
			wave.queue_free()
	active_waves.clear()
