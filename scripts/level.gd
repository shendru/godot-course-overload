extends Node2D

var enemy_counter = 0
@onready var enemies_container = $enemies

func spawn_enemy():
	var new_enemy = preload("res://scenes/enemy.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	enemies_container.add_child(new_enemy)

func _on_timer_timeout() -> void:
	spawn_enemy()
