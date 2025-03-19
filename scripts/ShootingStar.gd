extends Weapon
class_name ShootingStar

@export var spawn_y_offset : float = -50 
@export var random_x_interval : float = 30
@export var diagonal_direction : float = 0.0

func shoot(source, scene_tree):
	var projectile = projectile_node.instantiate()

	var player_position = source.global_position
	var random_x_offset = randf_range(-random_x_interval, random_x_interval)

	projectile.position = Vector2(player_position.x + random_x_offset, player_position.y + spawn_y_offset)
	projectile.damage = damage
	projectile.speed = speed
	projectile.source = source

	var direction = Vector2(diagonal_direction, 1.0).normalized()
	projectile.direction = direction

	if texture != null:
		if projectile.has_node("Sprite2D"):
			projectile.get_node("Sprite2D").texture = texture

	scene_tree.current_scene.add_child(projectile)

func activate(source, _target, scene_tree):
	shoot(source, scene_tree) # Target is not needed for ShootingStar

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
	level += 1
