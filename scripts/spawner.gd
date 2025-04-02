extends Node2D
 
@export var player : CharacterBody2D
@export var enemy : PackedScene
@export var enemy_types : Array[Enemy]

@export var grass : PackedScene
@export var grass_limit : int = 60
@export var grass_types : Array[Grass]

@export var hazard_types : Array[Enemy]
@export var hazard_area : PackedScene = preload("res://scenes/hazard_area_2d.tscn")
var grass_counter:int = 0:
	set(value):
		grass_counter = value
		%GrassCounter.text = "Grass count: " + str(value)

var distance : float = 800
var initial_grass_radius: float = 400

var drop = preload("res://scenes/pickups.tscn")

var enemy_counter :int = 0:
	set(value):
		enemy_counter = value
		%EnemyCounter.text = "Enemies count: " + str(value)

var minute : int:
	set(value):
		minute = value
		%Minute.text = str(value)
 
var second : int:
	set(value):
		second = value
		if second >= 10:
			second -= 10
			minute += 1
		%Second.text = str(second).lpad(2,'0')

func _ready():
	init_some_grass()
	pass

func spawn(pos : Vector2, elite : bool = false):
	var enemy_instance = enemy.instantiate()
	enemy_instance.type = enemy_types[min(minute, enemy_types.size()-1)]
	#enemy_instance.position = get_random_position()
	enemy_instance.position = pos
	enemy_instance.player_reference = player
	enemy_instance.elite = elite
	enemy_instance.connect("died", _on_enemy_died)
	get_tree().current_scene.add_child.call_deferred(enemy_instance)
	enemy_counter+=1

func spawnGrass(pos : Vector2):
	var grass_instance = grass.instantiate()
	grass_instance.type = grass_types.pick_random()
	grass_instance.position = pos
	grass_instance.player_reference = player
	grass_instance.connect("on_grass_free", _on_grass_free)
	get_tree().current_scene.add_child.call_deferred(grass_instance)
	grass_counter += 1

func spawnHazards(pos : Vector2):
	var hazard_instance = hazard_area.instantiate()
	hazard_instance.type = hazard_types.pick_random()
	#hazard_instance.position = get_random_position()
	hazard_instance.position = pos
	hazard_instance.player_reference = player
	get_tree().current_scene.add_child.call_deferred(hazard_instance)

func init_some_grass():
	var initial_grass_count = min(grass_limit, 20)
	for i in range(initial_grass_count):
		var pos = get_random_position_radius(initial_grass_radius)
		spawnGrass(pos)

func _on_timer_timeout():
	second += 1
	amount(second % 10)
 
 
func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))

func get_random_position_radius(radius: float) -> Vector2:
	var random_angle = randf_range(0, 2 * PI)
	var random_radius = sqrt(randf()) * radius
	return player.position + Vector2.RIGHT.rotated(random_angle) * random_radius

func spawn_in_circle(count: int, radius: float):
	for i in range(count):
		var angle = i * (2 * PI / count) 
		var spawn_pos = player.position + Vector2.RIGHT.rotated(angle) * radius
		spawnHazards(spawn_pos)

 
func amount(number : int = 1):
	for i in range(number):
		spawn(get_random_position())
		if grass_counter < grass_limit:
			spawnGrass(get_random_position())
			spawnGrass(get_random_position())
 
 
func _on_pattern_timeout():
	for i in range(10):
		spawn(get_random_position())
		spawnGrass(get_random_position())
 
 
func _on_elite_timeout():
	spawn(get_random_position(), true)

func _on_enemy_died():
	enemy_counter-=1

func _on_grass_free():
	grass_counter -= 1


func _on_hazard_timeout() -> void:
	spawn_in_circle(9, 240)
