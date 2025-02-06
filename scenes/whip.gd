extends Marker2D

@export var level = 1

func _ready() -> void:
	$whipTimer.start()

func whip_timer() -> void:
	print("time")
	spawnWhip()

func spawnWhip() -> void:
#	SPRITE ANIMATION OF WHIP
	const whip_collision = preload("res://components/whip_collision.tscn")
	var new_whip = whip_collision.instantiate()
	add_child(new_whip)
	print("new WHIP!")
