extends Pickups
class_name ExpItem

@export var XP: float

func activate():
	super.activate()
	prints("+" + str(XP) + "XP")
	player_reference.gain_XP(XP)
