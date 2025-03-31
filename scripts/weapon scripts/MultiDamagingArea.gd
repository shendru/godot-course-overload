extends Weapon
class_name MultiDamagingArea

@export var amount : int =  1
@export var area : float = 3
@export var lifetime : float = 2.0
@export var delay : float = 0.2
@export var spawn_on_source : bool = false
var counter : float = 0

var projectile_reference = []

func activate(source, _target, scene_tree):
	reset()
	for i in range(amount):
		add_to_world(source, scene_tree)

	if spawn_on_source:
		for projectile in projectile_reference:
			projectile.position = source.global_position
			projectile.show()
	else:
		for i in range(projectile_reference.size()):
			var offset = i * (360.0/amount)
			projectile_reference[i].position = source.position + 200 * Vector2(cos(deg_to_rad(offset)), sin(deg_to_rad(offset)))
			projectile_reference[i].show()
		
	print("num of projectiles:"+str(projectile_reference.size()))
	

func add_to_world(source, tree):
	var projectile = projectile_node.instantiate()
	projectile.speed = 0
	projectile.damage = damage
	projectile.source = source
	projectile.scale  = Vector2(area,area)
	projectile.z_index = 0
	if texture != null:
		if projectile.has_node("Sprite2D"):
			projectile.get_node("Sprite2D").texture = texture

	projectile.hide()
	projectile_reference.append(projectile)
	
	tree.current_scene.call_deferred("add_child",projectile)
	# Create and attach a Timer to the projectile
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(Callable(self, "_on_projectile_timeout").bind(projectile))
	projectile.add_child(timer)

func _on_projectile_timeout(projectile: Node2D):
	if is_instance_valid(projectile):
		projectile.queue_free()
		projectile_reference.erase(projectile)

func upgrade_item():
	if max_level_reached():
		slot.item = evolution
		return

	if not is_upgradable():
		return

	var upgrade = upgrades[level - 1]

	area += upgrade.area
	damage += upgrade.damage
	amount += upgrade.amount
	cooldown += upgrade.cooldown

	level += 1

func reset_collision(value):
	#print(value)
	for projectile in projectile_reference:
		if is_instance_valid(projectile):
			if projectile.has_node("CollisionShape2D"):
				projectile.get_node("CollisionShape2D").disabled = value

func reset():
	for temp in projectile_reference:
		if is_instance_valid(temp):
			temp.queue_free()
	projectile_reference.clear()

func update(delta):
	counter += delta

	if counter > 2 * delay and projectile_reference.size() > 0:
		reset_collision(false)
		counter = 0
	elif counter > delay and projectile_reference.size() > 0:
		reset_collision(true)
