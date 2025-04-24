extends Area2D
class_name ProjectileNode

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
 
# 🚀 New sinusoidal movement properties
var wave_motion: bool = false
var wave_amplitude: float = 1024
var wave_frequency: float = 8

var spawn_origin: Vector2
var wave_timer: float = 0.0

func _ready() -> void:
	spawn_origin = global_position
	if "attack_aoe" in source:
		scale += Vector2(source.attack_aoe, source.attack_aoe)
	if vfx != null:
		var new_vfx = vfx.instantiate()
		add_child(new_vfx)

func _physics_process(delta):
	wave_timer += delta

	if wave_motion:
		var forward = direction.normalized()
		var right = Vector2(-forward.y, forward.x) # Perpendicular to direction
		var wave_offset = sin(wave_timer * wave_frequency * TAU) * wave_amplitude
		global_position = spawn_origin + forward * speed * wave_timer + right * wave_offset
	else:
		position += direction * speed * delta

	if allow_rotation:
		rotation += TAU * delta
	
	
 
 
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
