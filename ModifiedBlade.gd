extends Weapon
class_name ModifiedBlade

@export var lifetime : float = 0.5
@export var area : float = 1
@export var attack_both_sides: bool = false
@export var knockback: float = 10


func activate(source, _target, scene_tree):
	var base_dir = (source.get_global_mouse_position() - source.position).normalized()
	var perpendicular = Vector2(-base_dir.y, base_dir.x)
	var directions = [1]

	if attack_both_sides:
		directions = [1, -1]

	for dir_mul in directions:
		var projectile = projectile_node.instantiate()
		#projectile.position = source.aim.position + perpendicular * 10 * dir_mul
		#projectile.position = source.aim.position
		projectile.rotation = source.aim.rotation + (PI if dir_mul == -1 else 0)
		
		projectile.speed = speed
		projectile.damage = damage
		projectile.source = source
		projectile.scale = Vector2(area, area)
		projectile.direction = base_dir * dir_mul
		projectile.knockback = knockback

		if projectile.has_node("Lifetime"):
			projectile.get_node("Lifetime").wait_time = max(lifetime,0.1)
		if texture != null:
			projectile.find_child("Sprite2D").texture = texture
		if vfx != null:
			projectile.vfx = vfx
			if afterFx != null:
				projectile.afterFx = afterFx
			if afterFxMAX != null and "afterFxMAX" in projectile and max_level_reached():
				projectile.afterFxMAX = afterFxMAX

		source.offset.add_child(projectile)
		await scene_tree.create_timer(0.16).timeout





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
	knockback += upgrade.knockback

	if upgrade.enable_both_sides:
		attack_both_sides = true

	level += 1
