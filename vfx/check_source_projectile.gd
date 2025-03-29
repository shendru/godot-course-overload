extends Node2D

var source
var afterFx:PackedScene

func _ready() -> void:
	#if source:
		#print("source exists"+str(source))
	if "lifetime" in source:
		$Lifetime.wait_time = 2
		$PreLifetime.wait_time = source.lifetime.wait_time - 2
		$PreLifetime.start()
		
func runAnim():
	$AnimationPlayer.play("default")
	
func emitParticle1():
	$GPUParticles2D.emitting = true
	
func emitParticle2():
	$GPUParticles2D2.emitting = true
	
func emitParticle3():
	$GPUParticles2D3.emitting = true
	$GPUParticles2D4.emitting = true
func _on_timer_timeout() -> void:
	emitParticle2()
	$GPUParticles2D.emitting = false
	if afterFx!=null:
		var new_afterFx = afterFx.instantiate()
		new_afterFx.source = self
		get_tree().current_scene.add_child(new_afterFx)
	$Sprite2D4.queue_free()
	


func _on_pre_lifetime_timeout() -> void:
	emitFx()

func emitFx(xtra: bool = false):
	$PreLifetime.stop()
	$Lifetime.start()
	if xtra:
		emitParticle3()
	emitParticle1()
	runAnim()
