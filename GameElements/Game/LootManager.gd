class_name LootManager
extends Node



const loot_types = ["rings", "necklaces", "pants", "boots"]
const loot_textures = [rings_texture,necklace_texture,pants_texture,boots_texture]
const boots_texture = preload("res://Assets/loots/boots.png")
const rings_texture = preload("res://Assets/loots/rings.png")
const necklace_texture = preload("res://Assets/loots/necklaces.png")
const pants_texture = preload("res://Assets/loots/pants.png")

static func add_loot_to_enemy(enemy: Node2D):
	#best chance is 0.005
	var hat_chance = 0.002
	var loot_chance = 0.02
	var value = randf()
	if value <= hat_chance && !(Global.unlocked_hats.values().all(func(value):return value==true)):
		enemy.add_hat(get_index_of_random_available_hat())
		return
	if value <= loot_chance:
		print("Adding loot to Enemy")
		enemy.add_loot(generate_random_loot())
	
		
static func get_index_of_random_available_hat() -> int:
	var rand_index = randi_range(0, Global.unlocked_hats.size() -1)
	if Global.unlocked_hats.values()[rand_index]:
		return get_index_of_random_available_hat()
	else:
		return rand_index
		
static func generate_random_loot() -> Loot:
	var rand_type = randi_range(0,loot_types.size() - 1)
	var rand_primary_stat = randi_range(1,5)
	var rand_secondary_stat = randi_range(1,5)
	var rand_primary_stat_value = 0
	var rand_secondary_stat_value = 0
	if Shop.is_open :
		rand_type = Shop.selected_type
		rand_primary_stat_value = randi_range(0,5) * Global.urgent_quests_completed
		rand_secondary_stat_value = randi_range(0,4) * Global.urgent_quests_completed
	else:
		rand_primary_stat_value = randi_range(0,5) * Global.selected_difficulty
		rand_secondary_stat_value = randi_range(0,4) * Global.selected_difficulty
	var rarity: int = (rand_primary_stat_value + rand_secondary_stat_value) / 7
	var modulate = get_modulate_color(rarity)
	while rand_primary_stat == rand_secondary_stat:
		rand_secondary_stat = randi_range(1,5)
	var loot_to_return = Loot.new()
	loot_to_return.type = loot_types[rand_type]
	loot_to_return.texture = loot_textures[rand_type]
	loot_to_return.primary_stat = rand_primary_stat
	loot_to_return.primary_stat_value = rand_primary_stat_value
	loot_to_return.secondary_stat = rand_secondary_stat
	loot_to_return.secondary_stat_value = rand_secondary_stat_value
	loot_to_return.rarity = rarity
	loot_to_return.modulate = modulate
	print("loot added = %s" % loot_to_return)
	return loot_to_return
	
static func get_modulate_color(rarity: int) -> Color:
	print("Rarity = %s" % rarity)
	var color = Color.ALICE_BLUE
	match rarity:
		0:
			color = Color.BISQUE
			color += Color(1,1,1,0)
		1:
			color = Color.PALE_GREEN
			color += Color(0,1,0,0)
		2:
			color = Color.CORNFLOWER_BLUE
			color += Color(0,0,1,0)
		3:
			color = Color.DARK_VIOLET
			color += Color(1,0,1,0)
		4:
			color = Color.GOLD
			color += Color(0,1,1,0)
		5:
			color = Color.FIREBRICK
			color += Color(1,0,0,0)
	return color 
