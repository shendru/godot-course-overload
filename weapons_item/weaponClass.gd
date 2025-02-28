extends Node2D
class_name weaponClass

# Weapon properties
var size: float = 1
var dmg : float = 1
var attack_speed: float = 1
var collission: bool = false
var WEAP : PackedScene
var level: int = 1
@onready var timer: Timer = %Timer


func attack_lvl1():
	var new_attack = WEAP.instantiate()
	new_attack.dmg = dmg
	add_child(new_attack)
	
func _on_timer_timeout() -> void:
	print("timer inside Weapon class")
	attack_lvl1()
