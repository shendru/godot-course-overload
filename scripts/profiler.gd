extends CanvasLayer

@onready var enemy_counter: Label = %EnemyCounter
@onready var fps_label: Label = %FPSLabel
@onready var memory_label: Label = %MemoryLabel

func _process(_delta):
	# FPS
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

	# Memory Usage (in MB)
	var memory_usage = OS.get_static_memory_usage() / 1024.0 / 1024.0
	memory_label.text = "Memory: " + str(memory_usage).left(5) + " MB"

func _on_level_update_enemy_counter(count: int) -> void:
	enemy_counter.text = "Enemy Counter: "+str(count)
