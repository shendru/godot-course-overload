extends Item
class_name PassiveItem
 
@export var upgrades : Array[Stats]
var player_reference
 
func is_upgradable() -> bool:
	if level <= upgrades.size():
		return true
	return false
 
func upgrade_item():
	if not is_upgradable():
		return
 
	if player_reference == null:
		print("passive item player reference is null")
		return
 
	var upgrade = upgrades[level - 1]
 
	player_reference.max_health += upgrade.max_health
	player_reference.recovery += upgrade.recovery
	player_reference.armor += upgrade.armor
	player_reference.movement_speed += upgrade.movement_speed
	player_reference.might += upgrade.might
	player_reference.attack_aoe += upgrade.attack_aoe
	player_reference.magnet += upgrade.magnet
	player_reference.growth += upgrade.growth
	player_reference.luck += upgrade.luck 
	player_reference.weapon_knockback += upgrade.weapon_knockback

	level += 1
 
