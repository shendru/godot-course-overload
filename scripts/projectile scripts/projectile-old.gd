extends Area2D
#class_name ProjectileNode

var direction : Vector2 = Vector2.RIGHT
var speed : float = 200
var damage : float = 1
var knockback : float = 10

var vfx: PackedScene
var afterFx : Array[PackedScene]
var afterFxMAX : PackedScene

var source
var knockback_on_source: bool = false

var allow_rotation = false
 
func _ready() -> void:
	if "attack_aoe" in source:
		scale += Vector2(source.attack_aoe,source.attack_aoe)
	if vfx!=null:
		var new_vfx = vfx.instantiate()
		add_child(new_vfx)

func _physics_process(delta):
	position += direction * speed * delta
	if not allow_rotation:
		pass
	else:
		rotation += 2.0 * PI * delta
	
	
 
 
func _on_body_entered(body):
	#print("some body entered")
	if body.has_method("take_damage"):
		if source and "might" in source:
			body.call_deferred("take_damage", damage * source.might)
		else:	
			body.call_deferred("take_damage", damage)
		if source:
			var knockback_direction: Vector2
			if not knockback_on_source:
				knockback_direction = (body.position - global_position).normalized()
			else:
				knockback_direction = (body.position - source.position).normalized()
			var knockback_to_add = knockback_direction * (knockback + source.weapon_knockback)
			#body.knockback = knockback_direction * (knockback + source.weapon_knockback)
			body.add_knockback(knockback_to_add)
		else:
			body.add_knockback(direction* knockback)
 
 
func _on_screen_exited():
	queue_free()
