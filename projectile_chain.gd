extends ProjectileNode

@onready var qfree_timer = $QFreeTimer

@export var chain_limit: int = 3  # Maximum number of chains allowed
@export var chain_radius: float = 200 # How far to look for the next enemy

# This will track how many chains have already happened.
var chain_count: int = 0
# List of enemies that have already been hit; helps avoid looping back.
var already_hit: Array = []

var chaining = false

func _on_body_entered(body):
	super(body)
	if not chaining:
		chain_to_target(body)
		chaining = true

# Call this function to begin chaining to a specific target.
func chain_to_target(target_enemy) -> void:
	if not is_instance_valid(target_enemy):
		queue_free()
		return

	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_enemy.global_position, 0.1)
	tween.tween_callback(Callable(self, "on_hit_enemy").bind(target_enemy))


# Called when the projectile “hits” an enemy.
func on_hit_enemy(enemy) -> void:
	$CollisionShape2D.disabled = true
	if not is_instance_valid(enemy):
		queue_free()  # or return, if you want to end this chain gracefully
		return

	if enemy not in already_hit:
		already_hit.append(enemy)
	
	chain_count += 1

	if chain_count < chain_limit:
		call_deferred("chain_to_nearby_enemy", enemy)
	else:
		# End the chain.
		pass
		#queue_free()


# This function looks for a nearby enemy (not already hit) to chain to.
func chain_to_nearby_enemy(current_enemy) -> void:
	if not is_instance_valid(current_enemy):
		queue_free()
		return

	var enemies = get_tree().get_nodes_in_group("Enemy")
	var valid_targets = []
	
	for e in enemies:
		# Check validity and skip if already hit.
		if not is_instance_valid(e) or (e in already_hit):
			continue
		if current_enemy.global_position.distance_to(e.global_position) <= chain_radius:
			valid_targets.append(e)
	if valid_targets.is_empty():
		queue_free()
		return
	
	var next_enemy = valid_targets.pick_random()
	
	var projectile_scene = preload("res://scenes/projectile_chain.tscn")  # Adjust path as needed
	var new_projectile = projectile_scene.instantiate()
	
	new_projectile.speed = 0
	new_projectile.damage = damage
	new_projectile.chain_count = chain_count
	new_projectile.chain_limit = chain_limit
	new_projectile.chain_radius = chain_radius
	new_projectile.already_hit = already_hit.duplicate()
	
	new_projectile.position = current_enemy.global_position
	new_projectile.chaining = true
	get_parent().add_child(new_projectile)
	
	new_projectile.chain_to_target(next_enemy)
	
	# Optionally free this projectile after spawning the next segment.
	# queue_free()



func _on_timer_timeout() -> void:
	queue_free()
func _on_screen_exited():
	pass
