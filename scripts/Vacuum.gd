extends Pickups
class_name Vacuum

@export var isStartingPickup:bool = false

func activate():
	super.activate()
	player_reference.get_tree().call_group("Pickups", "follow", player_reference, true)
	if not isStartingPickup:
		pass
	else:
		player_reference.get_parent().find_child("StartArea2d").activate()
