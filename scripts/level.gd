extends Node2D

var enemy_counter: int = 0
@onready var enemies_container = $enemies

signal update_enemy_counter(count: int)

func spawn_enemy():
	var new_enemy = preload("res://scenes/enemy.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	enemies_container.add_child(new_enemy)
	enemy_counter += 1
	update_enemy_counter.emit(enemy_counter)
	new_enemy.connect("died", _on_enemy_died)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		spawn_enemy()
		if get_tree().paused == true:
			get_tree().paused = false
		else:
			get_tree().paused = true

func _on_enemy_died():
	enemy_counter -= 1
	update_enemy_counter.emit(enemy_counter)


func _on_timer_timeout() -> void:
	spawn_enemy()
