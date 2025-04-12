extends Weapon
class_name SpawnArray

@export var lifetime: float = 1
@export var area: float = 1
@export var mult_collision_shape: float = 0
## Collision on and off interval delay
@export var delay: float = 0.2
@export var spawn_once: bool = true
@export var knockback: float = 90

@export var amount: int = 1

#@export_group("Self Free Explode")
#@export var has_pre_lifetime: bool = false
#@export var pre_lifetime:float = 0


var projectile_reference = []

func spawn(source, _target, scene_tree):
	if projectile_reference.size()>=1 and spawn_once:
		return
	for i in range(amount):
		var projectile = projectile_node.instantiate()
		if projectile.has_node("Lifetime"):
			projectile.get_node("Lifetime").wait_time = lifetime
		if "delay" in projectile:
			projectile.delay = delay
		
		projectile.damage = damage
		projectile.speed = speed
		projectile.source = source
		projectile.scale = Vector2(area,area)
		projectile.knockback = knockback
	
		var offset = -i * (360.0/amount)
		projectile.position = source.position + 100 * Vector2(cos(deg_to_rad(offset)), sin(deg_to_rad(offset)))
		projectile.initial_angle = deg_to_rad(offset)
		projectile.rotation = deg_to_rad(offset)
		
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
		projectile.tree_exited.connect(Callable(self, "_on_tree_exitted").bind(projectile))
		projectile_reference.append(projectile)

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
	amount += upgrade.amount
	
	level += 1
