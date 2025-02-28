extends weaponClass


func _ready() -> void:
	attack_speed = 2
	WEAP = preload("res://weapons_item/bible_comp.tscn")
	timer = %Timer
	timer.set_wait_time(attack_speed)

func attack_lvl1():
	var new_attack = WEAP.instantiate()
	new_attack.dmg = dmg
	add_child(new_attack)


func _on_timer_timeout() -> void:
	attack_lvl1()
