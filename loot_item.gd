class_name LootItem
extends Control

var loot_texture: Texture = null
var loot_primary_stat : String = "primary undefined"
var loot_primary_stat_value : int = 0
var loot_secondary_stat : String = "secondary undefined"
var loot_secondary_stat_value : int = 0
var loot_rarity : int = 0
var loot_index : int = 0
var is_hat : bool = false
var hat_description: String = ""

signal loot_item_equip_pressed(index)
signal loot_item_sell_pressed(index)

func _ready():
	%ItemTexture.texture = loot_texture
	if is_hat:
		#For some reasons, without the print statement, the property is not loaded correctly.
		print("%s" % hat_description)
		%RichTextLabel.text = "- [color=%s] %s [/color] -
[center]%s[/center]" % ["Orange", hat_description]
		%SellButton.visible = false
	else:
		%RichTextLabel.text = "- [color=%s] %s [/color] -
%s : %s
%s : %s

price : [color=yellow] %s [/color]" % [get_rarity_color_name(loot_rarity), get_rarity_name(loot_rarity), loot_primary_stat, loot_primary_stat_value, loot_secondary_stat, loot_secondary_stat_value, loot_rarity + 1]
		%SellButton.text = "Sell : %s" % (loot_rarity + 1)
		%ItemTexture.modulate = get_rarity_color(loot_rarity)
	
	
func get_rarity_color_name(rarity:int) -> String:
	var color = ""
	match rarity:
		0:
			color = "Ivory"
		1:
			color = "Greenyellow"
		2:
			color = "Royalblue"
		3:
			color = "Blueviolet"
		4:
			color = "Gold"
		5:
			color = "Crimson"
	return color
	
func get_rarity_color(rarity:int) -> Color:
	var color = Color.WHITE
	match rarity:
		0:
			color = Color.IVORY
		1:
			color = Color.GREEN_YELLOW
		2:
			color = Color.ROYAL_BLUE
		3:
			color = Color.BLUE_VIOLET
		4:
			color = Color.GOLD
		5:
			color = Color.CRIMSON
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


func _on_equip_pressed():
	print("index of item = %s" % loot_index)
	loot_item_equip_pressed.emit(loot_index)


func _on_sell_pressed():
	loot_item_sell_pressed.emit(loot_index)
