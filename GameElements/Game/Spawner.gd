class_name Spawner
extends Node2D

static var enemies_spawn = 0
static var total_enemies = 0
static var enemies_left = 0
static var is_spawning = false
static var sequence_index : int = -1
static var number_of_time : int = 0
static var type_of_enemy : int = 0
static var spawn_index : int = 0
var map_of_game

func _ready():
	print("Spawner Ready !")
	sequence_index = -1
	enemies_left = 0
	enemies_spawn = 0
	total_enemies = 0
	is_spawning = false
	number_of_time = 0
	type_of_enemy = 0
	
func on_new_wave():
	enemies_spawn = 0

func spawn_flying_mob():
	if enemies_spawn >= total_enemies:
			is_spawning = false
			return
	else:
		if Game.current_wave > 2:
			enemies_spawn += 1
			var flying_enemy = preload("res://GameElements/Enemies/Slime/bat.tscn").instantiate()
			map_of_game.flyingSpawnPoint.progress_ratio = randf()
			flying_enemy.global_position = map_of_game.flyingSpawnPoint.global_position
			#Track when the flying enemy has been killed
			flying_enemy.slime_has_been_killed.connect(on_enemy_has_been_killed)
			get_parent().add_child(flying_enemy)
			spawn_visual_indicator(flying_enemy)
			number_of_time -= 1

func spawn_mob():
	
	#Load a new Enemy ( Path2DFollower ) and attach the relevent monster ( e.g slime, slimeMedium, archer...)
	var enemy = null
	# if infinity mode, ennemies spawner don't follow any sequence
	if Global.selected_difficulty == 99:
		if enemies_spawn >= total_enemies:
			is_spawning = false
			return
		else:
			var enemy_spawn_chance : float = randf()
			var medium_enemy_spawn_chance: float = (Game.current_wave)/(30)
			var fishmen_enemy_spawn_chance: float = (Game.current_wave)/80
			var hard_enemy_spawn_chance :float =  Game.current_wave/(150)
			var ghost_enemy_spawn_chance: float = (Game.current_wave)/200
			var mana_enemy_spawn_chance : float = 0.005
			if (enemy_spawn_chance < ghost_enemy_spawn_chance) && Game.current_wave > 9:
				enemy = preload("res://GameElements/Enemies/Slime/slime_ghost.tscn").instantiate()
			elif (enemy_spawn_chance < hard_enemy_spawn_chance) && Game.current_wave > 8:
				enemy = preload("res://GameElements/Enemies/Slime/slime_hard.tscn").instantiate()
			elif (enemy_spawn_chance < fishmen_enemy_spawn_chance) && Game.current_wave > 7:
				enemy = preload("res://GameElements/Enemies/Slime/fishmen.tscn").instantiate()
			elif (enemy_spawn_chance < medium_enemy_spawn_chance) && Game.current_wave > 3:
				enemy = preload("res://GameElements/Enemies/Slime/slime_medium.tscn").instantiate()
			elif enemy_spawn_chance > 1 - mana_enemy_spawn_chance:
				enemy = preload("res://GameElements/Enemies/Slime/slime_mana.tscn").instantiate()
			else:
				enemy = preload("res://GameElements/Enemies/Slime/slime.tscn").instantiate()
	else:
		if number_of_time == 0:
			if spawn_index + 2 == map_of_game.sequences[sequence_index].size():
				is_spawning = false
				return
			else:
				spawn_index += 2
				number_of_time = map_of_game.sequences[sequence_index][spawn_index]
				type_of_enemy = map_of_game.sequences[sequence_index][spawn_index + 1]
		print("Spawner : \nnumber of time = %s\nenemies spawn: %s\nenemies_left: %s\ntotal enemies for this wave : %s\nspawn index :  %s" % [number_of_time,enemies_spawn, enemies_left, total_enemies, spawn_index])
		match type_of_enemy:
			1: 
				enemy = preload("res://GameElements/Enemies/Slime/slime.tscn").instantiate()
			2:
				enemy = preload("res://GameElements/Enemies/Slime/slime_medium.tscn").instantiate()
			3:
				enemy = preload("res://GameElements/Enemies/Slime/slime_hard.tscn").instantiate()
			4: 
				spawn_flying_mob()
				return
			5: 
				enemy = preload("res://GameElements/Enemies/Slime/slime_mana.tscn").instantiate()
			6:
				enemy = preload("res://GameElements/Enemies/Slime/slime_ghost.tscn").instantiate()
			7:
				enemy = preload("res://GameElements/Enemies/Slime/fishmen.tscn").instantiate()
		number_of_time -= 1
	var follower = preload("res://GameElements/Enemies/Follower.tscn").instantiate()
	var indexSpawnPoints = randi_range(0,map_of_game.paths.size() - 1)
	map_of_game.paths[indexSpawnPoints].add_child(follower)
	follower.progress = 100
	follower.call_deferred("add_child", enemy)
	spawn_visual_indicator(follower)
	enemies_spawn += 1
	

func on_enemy_has_been_killed():
	enemies_left -= 1
	%EnemiesProgressBar.value = enemies_left
	%EnemiesLabel.text = "Wave %s : %s / %s" % [Game.current_wave,enemies_left, total_enemies]
	# This is the part to debug !
	# When there is no more enemy to spawn & the player just kille the last enemy then :
	# @enemies_left is decremented each time the player is killing an ennemy
	if enemies_left <= 0 && is_spawning == false && get_tree().get_nodes_in_group("Enemy").size() <= 1:
		print("Scene still have enemies %s" % get_tree().get_nodes_in_group("Enemy").size())
		$/root/Game.end_of_wave()
	
func spawn_visual_indicator(target):
	# Add a visual indicator for each Enemy spawned
	var indicator = preload("res://GameElements/misc/enemy_indicator.tscn").instantiate()
	get_node("/root/Game/Player").add_child(indicator)
	indicator.target = target
	indicator.global_position = get_node("/root/Game/Player").global_position
	
func _on_spawn_enemy_timer_timeout():
	spawn_mob()

func _on_spawn_flying_enemy_timer_timeout():
	if Global.selected_difficulty == 99 && Game.current_wave > 6:
		spawn_flying_mob()
