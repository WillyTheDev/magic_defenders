class_name Inventory
extends Resource

@export var loots = {
	"rings": [],
	"necklaces": [],
	"pants": [],
	"boots": []
}

@export var new_loots = {
	"rings": false,
	"necklaces": false,
	"pants": false,
	"boots": false
}

@export var equiped_rings : Loot = null
@export var equiped_necklaces : Loot = null
@export var equiped_pants : Loot = null
@export var equiped_boots : Loot = null

@export var equiped_player_damage = 0
@export var equiped_defense_range = 0
@export var equiped_defense_damage = 0
@export var equiped_defense_health = 0
@export var equiped_defense_fire_rate = 0

func update_equiped_stat(stat_index : int, value : int):
	match stat_index:
		1:
			equiped_player_damage += value
		2:
			equiped_defense_range += value
		3:
			equiped_defense_damage += value
		4:
			equiped_defense_health += value
		5:
			equiped_defense_fire_rate += value

