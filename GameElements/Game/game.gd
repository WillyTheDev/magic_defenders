class_name Game
extends Node2D

var total_enemies = 0
var increments_nb_enemies_per_wave = 8
var enemies_spawn = 0
var enemies_left = 0
var spawn_rates = 2
var spawn_flying_enemy_rates = 20

static var is_idle = true
static var is_on_hub = false
var map_of_game = Map
var paths: Array[Path2D] = []
var options_menu_open = false
var max_wave : float = 30.0
#Those variables are used to know which ennemy to spawn
var current_wave : float = 0.0
var sequence_index : int = -1
var spawn_index : int = 0
var number_of_time : int = 0
var type_of_enemy : int = 0
var is_spawning = true
static var game_is_over = true
signal wave_is_over
var sequence_enemies = {
	"slime_normale" : 0,
	"slime_medium" : 0,
	"slime_hard": 0,
	"bat": 0,
	"slime_mana": 0
}

# Use the _ready methode to reinitialize static properties from various classes
func _ready():
	current_wave = Global.starting_wave
	is_idle = true
	map_of_game = load("res://GameElements/Maps/map_%s.tscn" % Global.selected_map).instantiate()
	add_child(map_of_game)
	var player = preload("res://GameElements/Player/player.tscn").instantiate()
	player.player_update_mana_amount.connect(_on_player_player_update_mana_amount)
	player.player_got_new_hat.connect(_show_new_hat_animation)
	player.player_has_shoot.connect(%UI.update_ammo_bar)
	player.starting_mana_amount = map_of_game.player_starting_mana
	%UI.set_ammo_progress_max_value(player.base_ammo)
	player.global_position = map_of_game.get_node("PlayerSpawnPoint").global_position
	add_child(player)
	%TransitionLayer.open_transition()
	%BackgroundAudioPlayer.volume_db = Global.audio_volume
	if map_of_game.is_hub :
		is_on_hub = true
		%EnemiesProgressBar.visible = false
	else :
		is_on_hub = false
	Enemy.base_health = 1.0
	Enemy.base_speed = 5
	Enemy.base_damage = 1
	
	

func start_new_wave():
	for i in range(1, 8):
		get_node("UI/Progress Bar/VBoxContainer/EnemiesProgressBar/MarginContainer/HBoxContainer/Enemy_%s" % i).visible = false
	is_idle = false
	is_spawning = true
	spawn_rates -= 0.2
	spawn_flying_enemy_rates -= 0.1
	current_wave += 1
	sequence_index += 1
	total_enemies = 0
	var index = 0
	if Global.selected_difficulty < 4:
		while index != map_of_game.sequences[sequence_index].size():
			var value = map_of_game.sequences[sequence_index][index]
			var type = map_of_game.sequences[sequence_index][index + 1]
			match type:
				1:
					%Enemy_1.visible = true
				2:
					%Enemy_2.visible = true
				3:
					%Enemy_3.visible = true
				4:
					%Enemy_4.visible = true
				5:
					%Enemy_5.visible = true
				6: 
					%Enemy_6.visible = true
				7:
					%Enemy_7.visible = true
			total_enemies += value
			index += 2
		spawn_index = 0
		number_of_time = map_of_game.sequences[sequence_index][spawn_index]
		type_of_enemy = map_of_game.sequences[sequence_index][spawn_index + 1]
	else :
		total_enemies = current_wave * 8
	enemies_spawn = 0
	enemies_left = total_enemies
	#Update the UI accordingly
	%EnemiesProgressBar.max_value = total_enemies
	%EnemiesProgressBar.value = total_enemies
	%EnemiesLabel.text = "Wave %s : %s / %s" % [current_wave, enemies_left, total_enemies]
	%WaveActionLabel.visible = false
	
	#Start the Spawning timers
	%SpawnEnemyTimer.wait_time = clamp(spawn_rates, 0.5, 2.5)
	%SpawnEnemyTimer.start()
	%SpawnFlyingEnemyTimer.wait_time = clamp(spawn_flying_enemy_rates, 0.5, 2.5)
	%SpawnFlyingEnemyTimer.start()

	if current_wave > 5 && Global.selected_difficulty > 1:
		Enemy.base_health += Global.selected_difficulty - 1
		Enemy.base_speed += Global.selected_difficulty
		if Global.selected_difficulty > 2:
			Enemy.base_damage += Global.selected_difficulty / 2

func end_of_wave():
	%Enemy_1.visible = false
	%Enemy_2.visible = false
	%Enemy_3.visible = false
	%Enemy_4.visible = false
	%Enemy_5.visible = false
	%WaveLAbel.text = "Wave : %s Cleared !" % current_wave
	%UI.show_next_wave_label()
	%Confetti.play_confetti()
	%SpawnEnemyTimer.stop()
	%SpawnFlyingEnemyTimer.stop()
	%EnemiesLabel.text = ""
	%WaveActionLabel.visible = true
	# Give stars base on the current_wave
	if current_wave == map_of_game.sequences.size():
		%GameOverScreen.game_completed(current_wave, 3, map_of_game)
	is_idle = true
	wave_is_over.emit()

func spawn_flying_mob():
	if enemies_spawn >= total_enemies:
			is_spawning = false
			return
	else:
		if current_wave > 2:
			enemies_spawn += 1
			var flying_enemy = preload("res://GameElements/Enemies/Slime/bat.tscn").instantiate()
			map_of_game.flyingSpawnPoint.progress_ratio = randf()
			flying_enemy.global_position = map_of_game.flyingSpawnPoint.global_position
			#Track when the flying enemy has been killed
			flying_enemy.slime_has_been_killed.connect(on_enemy_has_been_killed)
			add_child(flying_enemy)
			spawn_visual_indicator(flying_enemy)
			number_of_time -= 1

func spawn_mob():
	#Load a new Enemy ( Path2DFollower ) and attach the relevent monster ( e.g slime, slimeMedium, archer...)
	var follower = preload("res://GameElements/Enemies/Enemy.tscn").instantiate()
	var enemy = null
	# if infinity mode, ennemies spawner don't foller any sequence
	if Global.selected_difficulty == 4:
		if enemies_spawn >= total_enemies:
			is_spawning = false
			return
		else:
			var enemy_spawn_chance : float = randf()
			var medium_enemy_spawn_chance: float = (current_wave)/(30)
			var hard_enemy_spawn_chance :float =  current_wave/(150)
			var mana_enemy_spawn_chance : float = 0.005
			if (enemy_spawn_chance < hard_enemy_spawn_chance) && current_wave > 7:
				enemy = preload("res://GameElements/Enemies/Slime/slime_hard.tscn").instantiate()
			elif (enemy_spawn_chance < medium_enemy_spawn_chance) && current_wave > 3:
				enemy = preload("res://GameElements/Enemies/Slime/slime_medium.tscn").instantiate()
			elif enemy_spawn_chance > 1 - mana_enemy_spawn_chance:
				enemy = preload("res://GameElements/Enemies/Slime/slime_mana.tscn").instantiate()
			else:
				enemy = preload("res://GameElements/Enemies/Slime/slime.tscn").instantiate()
	else:
		# follow a sequence
		if number_of_time == 0:
			if spawn_index + 2 == map_of_game.sequences[sequence_index].size():
				is_spawning = false
				return
			else:
				spawn_index += 2
				number_of_time = map_of_game.sequences[sequence_index][spawn_index]
				type_of_enemy = map_of_game.sequences[sequence_index][spawn_index + 1]
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
	# Connect a signal to track when an enemy has been killed
	enemy.slime_has_been_killed.connect(on_enemy_has_been_killed)
	# Add potential loot to enemy
	%LootManager.add_loot_to_enemy(enemy)
	
	# Add the enemy on a FollowerPath2D
	follower.add_child(enemy)
	follower.child = enemy
	# Add the Enemy on a random path
	var indexSpawnPoints = floor(randf() * map_of_game.paths.size())
	map_of_game.paths[indexSpawnPoints].add_child(follower)
	spawn_visual_indicator(follower.child)
	enemies_spawn += 1
	
func spawn_visual_indicator(target):
	# Add a visual indicator for each Enemy spawned
	var indicator = preload("res://GameElements/misc/enemy_indicator.tscn").instantiate()
	indicator.target = target
	indicator.global_position = get_node("Player").global_position
	get_node("Player").add_child(indicator)
	

func on_enemy_has_been_killed():
	enemies_left -= 1
	%EnemiesProgressBar.value = enemies_left
	%EnemiesLabel.text = "Wave %s : %s / %s" % [current_wave,enemies_left, total_enemies]
	# This is the part to debug !
	# When there is no more enemy to spawn & the player just kille the last enemy then :
	# @enemies_left is decremented each time the player is killing an ennemy
	if enemies_left <= 0 && is_spawning == false:
		print("Scene still have enemies %s" % get_tree().get_nodes_in_group("Enemy").size())
		end_of_wave()

func _input(event):
	if event.is_action_pressed("action_button"):
		if is_idle && map_of_game.is_hub == false:
			start_new_wave()

func _on_player_player_update_mana_amount(mana):
	%ManaLabel.text = "Mana : %s" % mana
	%SkillContainer.update_progress_bar()
	%AccumulatedManaLabel.text = "%s / %s until the next level" % [Global.accumulated_mana, (Player.offset_accumulated_mana_value + Global.player_level * 10)]
	%AccumulatedMana.max_value = Player.offset_accumulated_mana_value + Global.player_level * 10
	%AccumulatedMana.value = Player.accumulated_mana


func _on_spawn_enemy_timer_timeout():
		spawn_mob()

func _on_spawn_flying_enemy_timer_timeout():
	if Global.selected_difficulty == 4:
		spawn_flying_mob()

func _on_core_core_destroyed():
	%GameOverScreen.game_over(current_wave)


func _on_audio_stream_player_finished():
	%BackgroundAudioPlayer.play()


func _on_options_menu_audio_value_changed():
	%BackgroundAudioPlayer.volume_db = Global.audio_volume * 100.0
	

func _show_new_hat_animation(hat_index : int):
	%NewHatTexture.texture = load("res://Assets/hats/hat_%s.png" % hat_index)
	%UI/UIAnimationPlayer.queue("show_new_hat")


