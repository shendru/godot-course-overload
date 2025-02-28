extends Marker2D

@export var level = 2


func whip_timer() -> void:
	spawnWhip()

func spawnWhip() -> void:
#	SPRITE ANIMATION OF WHIP

	if level == 1:
		defaultWhip()
	elif level == 2:
		upgradedWhip()


func defaultWhip() -> void:
	const whip_collision = preload("res://components/whip_collision.tscn")
	var new_whip = whip_collision.instantiate()
	add_child(new_whip)

func upgradedWhip() -> void:
	const whip_collision = preload("res://components/whip_collision.tscn")
	var new_whip = whip_collision.instantiate()
	var new_whip2 = whip_collision.instantiate()
	add_child(new_whip)
	add_child(new_whip2)
	new_whip2.rotation_degrees = 180
