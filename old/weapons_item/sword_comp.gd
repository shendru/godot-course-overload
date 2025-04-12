extends Marker2D

var dmg: float = 1
@onready var animation_player = %AnimationPlayer
@onready var upgrade = %upgrade1
@onready var upgrade2 = %upgrade2

#func _ready():
	#if upgrade2:
		#print("upgrade2 node found in WEAP scene.")
	#else:
		#print("upgrade2 node NOT found in WEAP scene.")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.call_deferred("take_damage", dmg)

func toggleVisible():
	if upgrade2:
		#print("upgrade2 node found AGAIN.")
		upgrade2.visible = true
		animation_player.play("swing_2")
	#else:
		#print("none")
