extends Weapon
class_name Spawn

@export var lifetime: float = 1
@export var area: float = 1
@export var mult_collision_shape: float = 0
@export var delay: float = 0.2
@export var spawn_once: bool = true
@export var knockback: float = 90

#@export_group("Self Free Explode")
#@export var has_pre_lifetime: bool = false
#@export var pre_lifetime:float = 0


var projectile_reference = null

func spawn(source, _target, scene_tree):
	if is_instance_valid(projectile_reference) and spawn_once:
		return
	var projectile = projectile_node.instantiate()
	if projectile.has_node("Lifetime"):
		projectile.get_node("Lifetime").wait_time = lifetime
	if "delay" in projectile:
		projectile.delay = delay
	projectile.position = source.global_position
	projectile.damage = damage
	projectile.speed = speed
	projectile.source = source
	projectile.scale = Vector2(area,area)
	projectile.knockback = knockback
	if mult_collision_shape != 0:
		projectile.mult_collision_shape = mult_collision_shape
	if texture != null:
		projectile.find_child("Sprite2D").texture = texture
	
	if vfx != null:
		#var new_vfx = vfx.instantiate()
		#new_vfx.source = projectile
		projectile.vfx = vfx
		if afterFx !=null:
			projectile.afterFx = afterFx
		#projectile.add_child(new_vfx)
	scene_tree.current_scene.add_child(projectile)
	projectile_reference = projectile
 
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
	level += 1
