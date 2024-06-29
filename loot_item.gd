class_name LootItem
extends Control

var loot_texture: Texture = null
var stat_texture: Texture = null
var loot_primary_stat : String = "primary undefined"
var loot_primary_stat_value : int = 0
var loot_secondary_stat : String = "secondary undefined"
var loot_secondary_stat_value : int = 0
var loot_rarity : int = 0
var loot_index : int = 0
var is_hat : bool = false
var hat_description: String = ""
var is_equiped : bool = false

signal loot_item_equip_pressed(index)
signal loot_item_sell_pressed(index)

func _ready():
	if is_equiped:
		self_modulate = "78f8b5"
		%EquipButton.visible = false
		%SellButton.visible = false
	%ItemTexture.texture = loot_texture
	if is_hat:
		#For some reasons, without the print statement, the property is not loaded correctly.
		%RichTextLabel.text = "- [color=%s] %s [/color] -
		
%s" % ["Orange", "hat", hat_description]
		%SellButton.visible = false
		%StatTexture.visible = false
	else:
		%RichTextLabel.text = "- [color=%s] %s [/color] -
%s : [color=%s] %s [/color]
%s : [color=%s] %s [/color]" % [get_rarity_color_name(loot_rarity), get_rarity_name(loot_rarity), loot_primary_stat, get_stat_color_name(loot_primary_stat), loot_primary_stat_value, loot_secondary_stat, get_stat_color_name(loot_secondary_stat), loot_secondary_stat_value]
		%SellButton.text = "Sell : %s" % (loot_rarity + 1)
		%ItemBackground.self_modulate = get_rarity_color(loot_rarity)
		%StatTexture.texture = stat_texture
		%StatTexture.modulate = get_stat_color(loot_primary_stat)
	
	
func get_rarity_color_name(rarity:int) -> String:
	var color = ""
	match rarity:
		0:
			color = "DarkGray"
		1:
			color = "SeaGreen"
		2:
			color = "Royalblue"
		3:
			color = "Blueviolet"
		4:
			color = "Gold"
		5:
			color = "Crimson"
	return color
	
static func get_rarity_color(rarity:int) -> Color:
	var color = Color.WHITE
	match rarity:
		0:
			color = Color.DARK_GRAY
		1:
			color = Color.SEA_GREEN
		2:
			color = Color.ROYAL_BLUE
		3:
			color = Color.BLUE_VIOLET
		4:
			color = Color.GOLD
		5:
			color = Color.CRIMSON
	return color 

static func get_stat_color(name) -> Color:
	var color = Color.WHITE
	match name:
		"player damage":
			color = Color.INDIAN_RED
		"defense range":
			color = Color.ROYAL_BLUE
		"defense damage":
			color = Color.INDIAN_RED
		"defense health":
			color = Color.SEA_GREEN
		"defense Attack speed":
			color = Color.ORANGE
	return color
	
static func get_stat_name(value) -> String:
	var name = "player damage"
	match value:
		1:
			name = "player damage"
		2:
			name = "defense range"
		3:
			name = "defense damage"
		4:
			name = "defense health"
		5:
			name = "defense Attack speed"
	return name 

static func get_stat_color_name(name) -> String:
	var color = "Black"
	match name:
		"player damage":
			color = "IndianRed"
		"defense range":
			color = "RoyalBlue"
		"defense damage":
			color = "IndianRed"
		"defense health":
			color = "SeaGreen"
		"defense Attack speed":
			color = "Orange"
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
