extends ProjectileNode

@onready var pre_lifetime = $PreLifetime
@onready var lifetime = $Lifetime
@onready var after_lifetime = $AfterLifetime
@onready var emergency_exit = $EmergencyExit

var mult_collision_shape: float = 1
var flag:bool = true

var vfx_reference

func _ready() -> void:
	vfx_reference = vfx.instantiate()
	vfx_reference.afterFx = afterFx
	if afterFxMAX != null:
		vfx_reference.afterFxMAX = afterFxMAX
	vfx_reference.source = self
	add_child(vfx_reference)
	
	self.set_collision_mask_value(2, false)
	$CollisionShape2D.shape.radius = 0.01
	pre_lifetime.wait_time = max(lifetime.wait_time - 2, 1)
	emergency_exit.wait_time = 2.0
	after_lifetime.wait_time = 0.6
	pre_lifetime.start()


func _on_pre_lifetime_timeout() -> void:
	emitVfx()


func _on_after_lifetime_timeout() -> void:
	queue_free() # this is the part where i queue free

func emitVfx(xtra: bool = false):
	vfx_reference.emitFx(xtra)
	pre_lifetime.stop()
	emergency_exit.start()

func _on_emergency_exit_timeout() -> void:
	trigger()
	after_lifetime.start()
	
func trigger():
	self.set_collision_mask_value(2, true)
	$CollisionShape2D.shape.radius =  50.6 * mult_collision_shape
	$Sprite2D.texture = null

func _on_screen_exited():
	pass

func extra_condition():
	if flag:
		emitVfx(true)
		flag = false
