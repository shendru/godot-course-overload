extends Weapon
class_name SingleShot


@export var splashable: bool = false

@export var chainable: bool = false
@export var chain_limit:int = 5
@export var chain_radius:float = 200


func shoot(source, target, scene_tree):
	if target == null:
		return
 
	var projectile = projectile_node.instantiate()
 
	projectile.position = source.aim_pos.global_position
	projectile.damage = damage
	projectile.speed = speed
	projectile.source = source
	projectile.direction = target
	if chainable and "chainable" in projectile:
		print("chainable tru")
		projectile.chainable = true
		projectile.chain_limit = chain_limit
		projectile.chain_radius = chain_radius
	
	if vfx != null:
		projectile.vfx = vfx
	if texture != null:
		projectile.find_child("Sprite2D").texture = texture
	if rescale != 0:
		projectile.find_child("Sprite2D").scale = Vector2(rescale,rescale)
	scene_tree.current_scene.add_child(projectile)
 
func activate(source, target, scene_tree):
	shoot(source, target, scene_tree)

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
	if chainable:
		chain_limit += upgrade.chain_limit
		chain_radius += upgrade.chain_radius
	
	level += 1
