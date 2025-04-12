extends Resource
class_name Stats
 
@export_multiline var description : String
 
@export var max_health : float # max health
@export var recovery : float # health regen per second
@export var armor : float # subtracts the damage dealt by enemies
@export var movement_speed : float # movement speed
@export var might : float # is a multiple of weapon damage
@export var attack_aoe : float # adds to the AOE of attacks
@export var magnet : float # range of pickup
@export var growth : float # is a multiple of experience
@export var luck : float # affects crit (chance to deal double damage), also affects some chance based stuff, subject to change
@export var haste : float # cooldown/ time between attacks
@export var weapon_knockback : float # adds to the knockback of weapons
