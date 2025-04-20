extends Node2D

signal overload
var long_line: bool = false

@export var player : CharacterBody2D
@export var enemy : PackedScene
@export var enemy_types : Array[Enemy]
@export var enemy_event : PackedScene
@export var enemy_event_types : Array[Enemy]

@export var grass : PackedScene
@export var grass_limit : int = 60
@export var grass_types : Array[Grass]

@export var hazard_types : Array[Enemy]
@export var hazard_types_slow : Array[Enemy]
@export var hazard_types_fast : Array[Enemy]
@export var square_type: Array[hazardSquareType]
var square_type_index: int = 0

@export var hazard_area : PackedScene = preload("res://scenes/hazard_area_2d.tscn")
@export var hazard_area2 : PackedScene = preload("res://scenes/hazard_long_line.tscn")
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
				
var overload_phase: bool = false			

var second : int:
	set(value):
		second = value
		if second >= 10 and overload_phase:
			second -= 10
			minute += 1
			popp()
		elif second >= 60 and not overload_phase:
			second -= 60
			minute += 1
			overload_phase = true
			popp()
			overload.emit()
		%Second.text = str(second).lpad(2,'0')



func _ready():
	$Hazard.wait_time = randf() * 10 + 70
	$Hazard.start()
	
	$Hazard2.wait_time = randf() * 10 + 30
	$Hazard2.start()
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

func spawn_event(pos : Vector2, elite : bool = false):
	var enemy_instance = enemy_event.instantiate()
	
	enemy_instance.type = enemy_event_types[min(minute, enemy_event_types.size()-1)]
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

func spawnHazardsV2(pos : Vector2, index: int):
	var hazard_instance = hazard_area.instantiate()
	hazard_instance.type = hazard_types_slow[index]
	#hazard_instance.position = get_random_position()
	hazard_instance.position = pos
	hazard_instance.player_reference = player
	get_tree().current_scene.add_child.call_deferred(hazard_instance)

func spawnHazards2(pos : Vector2):
	var hazard_instance = hazard_area2.instantiate()
	hazard_instance.type = hazard_types_fast.pick_random()
	#hazard_instance.position = get_random_position()
	hazard_instance.position = pos
	hazard_instance.player_reference = player
	var direction = (player.position - pos).normalized()
	hazard_instance.direction = direction
	var rotation_angle = atan2(direction.y, direction.x)
	hazard_instance.rotation = rotation_angle
	get_tree().current_scene.add_child.call_deferred(hazard_instance)

func init_some_grass():
	var initial_grass_count = min(grass_limit, 20)
	for i in range(initial_grass_count):
		var pos = get_random_position_radius(initial_grass_radius)
		spawnGrass(pos)

 
 
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
		
func spawn_in_square(count: int, size: float):
	if count < 4:
		# If too small, fallback to corners
		var offsets = [
			Vector2(-1, -1), Vector2(1, -1),
			Vector2(1, 1), Vector2(-1, 1),
		]
		for i in range(count):
			var pos = player.position + offsets[i] * (size / 2)
			spawnHazards(pos)
		return

	var positions: Array[Vector2] = []
	var perimeter = size * 4
	var spacing = perimeter / count

	var current_pos = Vector2(-size / 2, -size / 2)  # Start top-left
	var dir = Vector2.RIGHT  # Initial direction
	var side_lengths = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

	var distance_travelled = 0.0
	var side_index = 0

	for i in range(count):
		positions.append(current_pos)
		current_pos += dir * spacing
		distance_travelled += spacing

		# Turn corner if needed
		if distance_travelled >= size:
			distance_travelled = 0.0
			side_index = (side_index + 1) % 4
			dir = side_lengths[side_index]

	for pos in positions:
		spawnHazardsV2(player.position + pos, min(square_type_index, hazard_types_slow.size()-1))



 
func amount(number : int = 1):
	for i in range(number):
		spawn(get_random_position())
		if long_line:
			spawnHazards2(get_random_position())
		if grass_counter < grass_limit:
			spawnGrass(get_random_position())
			spawnGrass(get_random_position())
 
func _on_timer_timeout():
	second += 1
	if overload_phase:
		amount(second % 10)
	else:
		amount(1)
 
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
	$Hazard.wait_time = randf() * 10 + 60
	$Hazard.start()


func _on_hazard_2_timeout() -> void:
	var count = square_type[min(square_type_index, square_type.size()-1)].count
	var square_radius = square_type[min(square_type_index, square_type.size()-1)].square_radius
	square_type_index += 1
	spawn_in_square(count,square_radius)
	$Hazard2.wait_time = randf() * 10 + 30
	$Hazard2.start()


func _on_hazard_long_line_timeout() -> void:
	$HazardLongLineEnd.start()
	long_line = true


func _on_hazard_long_line_end_timeout() -> void:
	long_line = false


func _on_unique_timer_1_timeout() -> void:
	spawn_event(get_random_position())

func popp():
	var tween = get_tree().create_tween()

	tween.tween_property(%Minute, "scale", Vector2(2, 2), 0.1)
	tween.tween_property(%Second, "scale", Vector2(2, 2), 0.1)

	tween.chain().tween_property(%Minute, "scale", Vector2(1, 1), 0.2)
	tween.chain().tween_property(%Second, "scale", Vector2(1, 1), 0.2)
