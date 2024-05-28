extends Node

#======================
# Player options selected
#======================

static var audio_volume = 0
static var sound_volume = 0

#======================
# Player Map selected
#======================

static var selected_chapter = 1
static var selected_map = 1
static var selected_difficulty = 1
static var starting_wave = 0
static var has_save = false
static var player_equipped_hat = 99
static var map_progression = {
	"map_1_1" : 0,
	"map_1_2" : 0,
	"map_1_3" : 0,
	"map_1_4" : 0,
	"map_1_5" : 0,
	"map_1_6" : 0
}

static var accumulated_stars = 0

static var unlocked_hats:  = {
	"hat_0" : false,
	"hat_1" : false,
	"hat_2" : false,
	"hat_3" : false,
	"hat_4" : false,
	"hat_5" : false,
	"hat_6" : false
}

static var inventory : Inventory = null

#======================
# Player Data
#======================
static var player_level = 0
static var accumulated_mana = 0
static var accumulated_gold = 0

#======================
# Player Stats
#======================
static var player_base_damage = 0.5
static var player_stat_damage = clamp(0, 0.5, 50)
static var player_divider_damage = 3.0

func getPlayerDamage():
	return (player_base_damage + (player_base_damage / player_divider_damage) * player_stat_damage)

static var defense_base_range = 1.0
static var defense_stat_range = clamp(0, 1.0, 1000.0)
static var defense_divider_range = 25.0

func getDefenseRange():
	return (defense_base_range + (defense_base_range / defense_divider_range) * defense_stat_range)

static var defense_base_damage = 1.0
static var defense_stat_damage = clamp(0, 1.0, 1000.0)
static var defense_divider_damage = 5.0

func getDefenseDamage():
	print("Defense_stat_damage = %s " % defense_stat_damage)
	print("DEFENSE DAMAGE =  %s" % ((defense_base_damage / defense_divider_damage) * defense_stat_damage))
	return (defense_base_damage + (defense_base_damage / defense_divider_damage) * defense_stat_damage)

static var defense_base_health = 10.0
static var turret_base_health = 2.0
static var defense_stat_health = clamp(0, 1.0, 1000.0)
static var defense_divider_health = 3.0

func getDefenseHealth():
	return  (defense_base_health + (defense_base_health / defense_divider_health) * defense_stat_health)
	
func getTurretHealth():
	return (turret_base_health + (turret_base_health / defense_divider_health) * defense_stat_health)

static var defense_base_fire_rate = 2.0
static var defense_stat_fire_rate = clamp(0, 1.0, 1000.0)
static var defense_divider_fire_rate = -133.0

func getDefenseFireRate():
	return (defense_base_fire_rate +(defense_base_fire_rate / defense_divider_fire_rate) * defense_stat_fire_rate)

static var player_avail_pts = 0
#Player equipped hat ( number represent index of hat )


#======================
# Player Skills
#======================

static var unlocked_skills = {
	"skill_0": true,
	"skill_1": true,
	"skill_2": true,
	"skill_3": true
}

static var selected_skills = {
	"skill_0": 0,
	"skill_1": 1,
	"skill_2": 2,
	"skill_3": 3,
}

#======================
# Game Progression
#======================



func get_accumulated_stars():
	accumulated_stars = 0
	for map in map_progression:
		accumulated_stars += map_progression[map]

func getStatFromIndex(index: int) -> int:
	match index:
		1:
			return player_stat_damage
		2:
			return defense_stat_range
		3:
			return defense_stat_damage
		4:
			return defense_stat_health
		5:
			return defense_stat_fire_rate
		_:
			return 0
			
func setStatFromIndex(index: int, value: int):
	match index:
		1:
			player_stat_damage += value
		2:
			defense_stat_range += value
		3:
			defense_stat_damage += value
		4:
			defense_stat_health += value
		5:
			defense_stat_fire_rate += value
		_:
			return 0
			
			
#======================
# Save/Load System
#======================

func load_inventory():
	if ResourceLoader.exists("user://inventory.tres"):
		print("Inventory save Found !")
		inventory = ResourceLoader.load("user://inventory.tres")
		print(inventory)
		print(inventory.loots)
		print(inventory.equiped_rings)
	else:
		inventory = Inventory.new()

func save_inventory():
	var status = ResourceSaver.save(inventory, "user://inventory.tres")
	print("Saving inventory status : %s" % status)

func _save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"player_level" : player_level, # Vector2 is not supported by JSON
		"accumulated_mana" : accumulated_mana,
		"player_stat_damage" : player_stat_damage,
		"defense_stat_damage" : defense_stat_damage,
		"defense_stat_health" : defense_stat_health,
		"defense_stat_range" : defense_stat_range,
		"defense_stat_fire_rate" : defense_stat_fire_rate,
		"player_avail_pts": player_avail_pts,
		"player_equipped_hat" : player_equipped_hat,
		"accumulated_gold" : accumulated_gold,
		"accumulated_stars" : accumulated_stars,
		"map_progression" : map_progression,
		"audio_volume": audio_volume,
		"sound_volume": sound_volume,
		"unlocked_hats": unlocked_hats,
	}
	return save_dict
	
func new_save():
	var save = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var data = {
		"filename" : get_scene_file_path(),
		"player_level" : 1,
		"accumulated_mana" : 0,
		"player_stat_damage" : 0,
		"defense_stat_damage" : 0,
		"defense_stat_health" : 0,
		"defense_stat_range" : 0,
		"defense_stat_fire_rate" : 0,
		"player_avail_pts": 0,
		"player_equipped_hat" : 99,
		"accumulated_gold" : 0,
		"accumulated_stars" : 0,
		"map_progression" : {
							"map_1_1" : 0,
							"map_1_2" : 0,
							"map_1_3" : 0,
							"map_1_4" : 0,
							"map_1_5" : 0,
							"map_1_6" : 0
							},
		"audio_volume": 0,
		"sound_volume": 0,
		"unlocked_hats": {
							"hat_0" : false,
							"hat_1" : false,
							"hat_2" : false,
							"hat_3" : false,
							"hat_4" : false,
							"hat_5" : false,
							"hat_6" : false
						},
	}
	var inv = Inventory.new()
	print(inv.loots)
	var status = ResourceSaver.save(inv, "user://inventory.tres")
	print("Saving inventory status : %s" % status)
	var json_string = JSON.stringify(data)
	save.store_line(json_string)
	load_game()
	
func save_game():
	print("Saving data...")
	var save = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var data = _save()
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(data)
	save_inventory()
	# Store the save dictionary as a new line in the save file.
	save.store_line(json_string)
	
func load_game():
	print("Loading game...")
	if not FileAccess.file_exists("user://savegame.save"):
		has_save = false
		return
	
	has_save = true	
	var save = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save.get_position() < save.get_length():
		var json_string = save.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var data = json.get_data()

		# Now we set the remaining variables.
		for i in data.keys():
			if i == "filename" or i == "parent":
				continue
			print("Setting %s with value %s..." % [i, data[i]])
			set(i, data[i])
		print(unlocked_hats)
		load_inventory()
