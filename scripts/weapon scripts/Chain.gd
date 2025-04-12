extends Weapon
class_name Chain

@export var lifetime: float = 1
@export var area: float = 1
@export var mult_collision_shape: float = 0
@export var delay: float = 0.2
@export var spawn_once: bool = true
@export var knockback: float = 90

# New properties for chaining:
@export var chain_limit: int = 3
@export var chain_radius: float = 200.0

var projectile_reference = null

func spawn(source, _target, scene_tree):
	if is_instance_valid(projectile_reference) and spawn_once:
		return
	
	# Get a list of enemies and choose one at random
	
	var enemies = scene_tree.get_nodes_in_group("Enemy")
	if enemies.is_empty():
		return
	var first_enemy = enemies.pick_random()
	
	# Spawn the projectile at the enemy's position.
	var projectile = projectile_node.instantiate()
	
	# Configure projectile properties.
	if projectile.has_node("Lifetime"):
		projectile.get_node("Lifetime").wait_time = lifetime
	if "delay" in projectile:
		projectile.delay = delay
	# Instead of using source position, we use the enemy's position:
	projectile.position = first_enemy.global_position
	projectile.damage = damage
	projectile.speed = speed
	projectile.source = source
	projectile.scale = Vector2(area, area)
	projectile.knockback = knockback
	if mult_collision_shape > 0:
		projectile.mult_collision_shape = mult_collision_shape
	if texture != null:
		projectile.find_child("Sprite2D").texture = texture
	if rescale != 0:
		projectile.find_child("Sprite2D").scale = Vector2(rescale, rescale)
	if vfx != null:
		projectile.vfx = vfx
		if afterFx != null:
			projectile.afterFx = afterFx
		if afterFxMAX != null and "afterFxMAX" in projectile and max_level_reached():
			projectile.afterFxMAX = afterFxMAX
	
	# Pass along the chaining settings.
	projectile.chain_limit = chain_limit
	projectile.chain_radius = chain_radius
	# Optionally, initialize the list of already hit enemies with the first enemy.
	projectile.already_hit = [first_enemy]
	
	scene_tree.current_scene.add_child(projectile)
	projectile.chain_to_target(first_enemy)
	projectile_reference = projectile

func activate(source, target, scene_tree):
	spawn(source, target, scene_tree)

func upgrade_item():
	# ... (upgrade code remains unchanged)
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
