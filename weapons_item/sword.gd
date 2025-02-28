extends weaponClass

# For aiming
var aim: Marker2D
var aim_pos: Marker2D


func _ready() -> void:
	WEAP = preload("res://weapons_item/sword_comp.tscn")
	aim = %aim
	aim_pos = %aim_pos
	timer = %Timer
	
	timer.connect("timeout", self._on_timer_timeout)
	timer.set_wait_time(attack_speed)
	timer.start()

func attack_lvl1():
	var new_attack = WEAP.instantiate()
	new_attack.rotation = aim.rotation
	
	#new_attack.position = aim_pos.position
	new_attack.dmg = dmg
	add_child(new_attack)
	new_attack.animation_player.play("swing")

func attack_lvl2():
	var new_attack = WEAP.instantiate()
	
	new_attack.rotation = aim.rotation
	print("attack2")
	new_attack.call_deferred("toggleVisible")
	# note: call_deferred is the solution to the timing issue
	# alternative: find a way to pass parameters before instantiate
	
	#new_attack.animation_player.set_autoplay("swing_2")
	#new_attack.position = aim_pos.position
	new_attack.dmg = dmg
	add_child(new_attack)

func _on_timer_timeout() -> void:
	if level == 1:
		attack_lvl1()	
	if level == 2:
		attack_lvl2()



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print("space pressed, we are at lvl " + str(level))
		level = 2
