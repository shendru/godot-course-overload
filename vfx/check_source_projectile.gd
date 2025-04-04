extends Node2D

var source
var afterFx: Array[PackedScene]
var afterFxMAX : PackedScene

func _ready() -> void:
	#if source:
		#print("source exists"+str(source))
	if "lifetime" in source:
		$Lifetime.wait_time = 2
		$PreLifetime.wait_time = max(source.lifetime.wait_time - 2, 1)
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
	
func _on_lifetime_timeout() -> void:
	emitParticle2()
	$GPUParticles2D.emitting = false
	if afterFx!=null:
		for i in afterFx:
			var new_afterFx = i.instantiate()
			if "source" in new_afterFx:
				new_afterFx.source = self
			add_child(new_afterFx)
			#get_tree().current_scene.add_child(new_afterFx)
	if afterFxMAX != null:
		var new_afterFx = afterFxMAX.instantiate()
		if "source" in new_afterFx:
			new_afterFx.source = self
		add_child(new_afterFx)
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
