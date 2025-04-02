extends Pickups
class_name HealthPickup

@export var amount : int = 5

func activate():
	super.activate()
	player_reference.add_health(amount)
