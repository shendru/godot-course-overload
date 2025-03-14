extends Weapon
class_name MultiDamagingArea
 
@export var amount : int =  1
@export var area : float = 3
 
@export var delay : float = 0.2
var counter : float = 0
 
var projectile_reference = []
 
func activate(source, _target, scene_tree):
	reset()
	for i in range(amount):
		add_to_world(source, scene_tree)
 
	for i in range(projectile_reference.size()):
		var offset = i * (360.0/amount)
		projectile_reference[i].position = source.position + 100 * Vector2(cos(deg_to_rad(offset)), sin(deg_to_rad(offset)))
		projectile_reference[i].show()
 
 
func add_to_world(source, tree):
	var projectile = projectile_node.instantiate()
	projectile.speed = 0
	projectile.damage = damage
	projectile.source = source
	projectile.scale  = Vector2(area,area)
	projectile.z_index = 0
 
	if texture != null:
		projectile.find_child("Sprite2D").texture = texture
		projectile.find_child("Sprite2D").scale = Vector2(0.05, 0.05) #personal implementation
		projectile.find_child("Sprite2D").z_index = -1 #personal implementation
		projectile.find_child("Sprite2D").self_modulate = Color(0.7,0.2,0.1,1) #personal implementation
	projectile.find_child("CollisionShape2D").shape.radius = 12
	projectile.hide()
	projectile.knockback = -40
	projectile_reference.append(projectile)
 
	tree.current_scene.call_deferred("add_child",projectile)
 
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
	print(value)
	for projectile in projectile_reference:
		if is_instance_valid(projectile):
			projectile.find_child("CollisionShape2D").disabled = value
 
func reset():
	for i in range(projectile_reference.size()):
		var temp = projectile_reference.pop_front()
		if is_instance_valid(temp):
			temp.queue_free()
 
func update(delta):
	counter += delta
 
	if counter > 2 * delay and projectile_reference.size() > 0:
		reset_collision(false)
		counter = 0
	elif counter > delay and projectile_reference.size() > 0:
		reset_collision(true)
