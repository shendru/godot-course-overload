extends weaponClass


func _ready() -> void:
	attack_speed = 2
	WEAP = preload("res://weapons_item/bible_comp.tscn")
	timer.set_wait_time(attack_speed)
