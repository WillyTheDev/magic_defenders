class_name LootItem
extends Control

var loot_texture: Texture = null
var loot_primary_stat : String = "primary undefined"
var loot_primary_stat_value : int = 0
var loot_secondary_stat : String = "secondary undefined"
var loot_secondary_stat_value : int = 0
var loot_rarity : int = 0

func _ready():
	%ItemTexture.texture = loot_texture
	%RichTextLabel.text = "- [color=%s] %s [/color] -
%s : %s
%s : %s

price : [color=yellow] %s [/color]" % [get_rarity_color(loot_rarity), get_rarity_name(loot_rarity), loot_primary_stat, loot_primary_stat_value, loot_secondary_stat, loot_secondary_stat_value, loot_rarity + 1]
	
func get_rarity_color(rarity:int) -> String:
	var color = ""
	match rarity:
		0:
			color = "Ivory"
		1:
			color = "Greenyellow"
		2:
			color = "Royalblue"
		3:
			color = "Blueviole"
		4:
			color = "Gold"
		5:
			color = "Crimson"
	return color 

func get_rarity_name(rarity:int) -> String:
	var name = ""
	match rarity:
		0:
			name = "Common"
		1:
			name = "Uncommon"
		2:
			name = "Rare"
		3:
			name = "Epic"
		4:
			name = "Legendary"
		5:
			name = "???"
	return name
