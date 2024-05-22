class_name Game
extends Node2D

var total_enemies = 0
var increments_nb_enemies_per_wave = 8
var enemies_spawn = 0
var enemies_left = 0
var spawn_rates = 1.5
var spawn_flying_enemy_rates = 20

static var is_idle = true

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
	is_idle = true
	var map = load("res://GameElements/Maps/map_%s.tscn" % Global.selected_map).instantiate()
	add_child(map)
	map_of_game = map
	print(map_of_game.paths[0])
	var player = preload("res://GameElements/Player/player.tscn").instantiate()
	player.player_update_mana_amount.connect(_on_player_player_update_mana_amount)
	player.global_position = map.get_node("PlayerSpawnPoint").global_position
	add_child(player)
	%TransitionLayer.open_transition()
	%BackgroundAudioPlayer.volume_db = Global.audio_volume
	
	

func start_new_wave():
	%Enemy_1.visible = false
	%Enemy_2.visible = false
	%Enemy_3.visible = false
	%Enemy_4.visible = false
	%Enemy_5.visible = false
	print("Starting new wave !")
	is_idle = false
	is_spawning = true
	spawn_rates -= 0.2
	spawn_flying_enemy_rates -= 0.2
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
			print(value)
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

	if current_wave >= 5 && Global.selected_difficulty > 2:
		Enemy.base_health += map_of_game.enemy_health_increment
		Enemy.base_speed += map_of_game.enemy_speed_increment

func end_of_wave():
	%WaveLAbel.text = "Wave : %s Cleared !" % current_wave
	%UI.show_next_wave_label()
	%Confetti.play_confetti()
	%SpawnEnemyTimer.stop()
	%SpawnFlyingEnemyTimer.stop()
	%EnemiesLabel.text = ""
	%WaveActionLabel.visible = true
	Global.accumulated_gold += 1
	# Give stars base on the current_wave
	print(current_wave)
	match Global.selected_difficulty:
		1:
			if current_wave == map_of_game.sequences.size():
				%StarAnimation.play("show_first_star")
				if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 1:
					Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 1
					Global.get_accumulated_stars()
				game_completed()
				
		2:
			if current_wave == map_of_game.sequences.size():
				%StarAnimation.play("show_second_star")
				if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 2:
					Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 2
					Global.get_accumulated_stars()
				game_completed()
		3:
			if current_wave == map_of_game.sequences.size():
				%StarAnimation.play("show_third_star")
				if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 3:
					Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 3
					Global.get_accumulated_stars()
				game_completed()
		4:
			if current_wave == 30:
				if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 4:
					Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 4
					Global.unlocked_hats[map_of_game.win_hat_index] = true
					Global.get_accumulated_stars()
				game_completed()
		var other:
			print("current wave is %s" % other)
	is_idle = true
	wave_is_over.emit()

func spawn_flying_mob():
	if enemies_spawn >= total_enemies:
			is_spawning = false
			return
	else:
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
	print("Spawning new Enemy !")
	#Load a new Enemy ( Path2DFollower ) and attach the relevent monster ( e.g slime, slimeMedium, archer...)
	var follower = preload("res://GameElements/Enemies/Enemy.tscn").instantiate()
	var enemy = null
	# if infinity mode, ennemies spawner don't foller any sequence
	print("Difficulty selected = %s" % Global.selected_difficulty)
	if Global.selected_difficulty == 4:
		if enemies_spawn >= total_enemies:
			is_spawning = false
			return
		else:
			var enemy_spawn_chance : float = randf()
			var medium_enemy_spawn_chance: float = (current_wave)/(30)
			var hard_enemy_spawn_chance :float =  current_wave/(150)
			var mana_enemy_spawn_chance : float = 0.005
			if (enemy_spawn_chance < hard_enemy_spawn_chance) && current_wave > 15:
				enemy = preload("res://GameElements/Enemies/Slime/slime_hard.tscn").instantiate()
			elif (enemy_spawn_chance < medium_enemy_spawn_chance) && current_wave > 3:
				enemy = preload("res://GameElements/Enemies/Slime/slime_medium.tscn").instantiate()
			elif enemy_spawn_chance > 1 - mana_enemy_spawn_chance:
				enemy = preload("res://GameElements/Enemies/Slime/slime_mana.tscn").instantiate()
			else:
				enemy = preload("res://GameElements/Enemies/Slime/slime.tscn").instantiate()
	else:
		# follow a sequence$
		print("Number of enemy of the same type to spawn : %s" % number_of_time)
		if number_of_time == 0:
			if spawn_index + 2 == map_of_game.sequences[sequence_index].size():
				print(map_of_game.sequences[sequence_index].size())
				print("🐸 have Spawned all Enemy ! 🐸")
				is_spawning = false
				return
			else:
				spawn_index += 2
				number_of_time = map_of_game.sequences[sequence_index][spawn_index]
				type_of_enemy = map_of_game.sequences[sequence_index][spawn_index + 1]
				print("Type of Enemy ! %s" % type_of_enemy)
		match type_of_enemy:
			1: 
				print("Enemy type == 1")
				enemy = preload("res://GameElements/Enemies/Slime/slime.tscn").instantiate()
			2:
				print("Enemy type == 2")
				enemy = preload("res://GameElements/Enemies/Slime/slime_medium.tscn").instantiate()
			3:
				print("Enemy type == 3")
				enemy = preload("res://GameElements/Enemies/Slime/slime_hard.tscn").instantiate()
			4: 
				print("Enemy type == 4")
				spawn_flying_mob()
				return
			5: 
				print("Enemy type == 5")
				enemy = preload("res://GameElements/Enemies/Slime/slime_mana.tscn").instantiate()
			var other:
				print("WRONG ENEMY TYPE : %s" % other)
		number_of_time -= 1
	# Connect a signal to track when an enemy has been killed
	enemy.slime_has_been_killed.connect(on_enemy_has_been_killed)
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
	%EnemiesLabel.text = "%s / %s" % [enemies_left, total_enemies]
	# This is the part to debug !
	# When there is no more enemy to spawn & the player just kille the last enemy then :
	# @enemies_left is decremented each time the player is killing an ennemy
	if enemies_left <= 0 && is_spawning == false:
		end_of_wave()

func _input(event):
	if event.is_action_pressed("action_button"):
		if is_idle:
			start_new_wave()

func _on_player_player_update_mana_amount(mana):
	%ManaLabel.text = "Mana : %s" % mana
	%TurretButton/ProgressBarBackground.value = 20 - mana
	%DefenseButton/ProgressBarBackground.value = 10 - mana
	%MeteorButton/ProgressBarBackground.value = 60 - mana
	%AccumulatedManaLabel.text = "%s / %s until the next level" % [Global.accumulated_mana, (Player.offset_accumulated_mana_value + Global.player_level * 10)]
	%AccumulatedMana.max_value = Player.offset_accumulated_mana_value + Global.player_level * 10
	%AccumulatedMana.value = Player.accumulated_mana

func game_over():
	%GameOverScreen.visible = true
	%ScoreLabel.text = "The lotus has been destroyed\n %s waves" % current_wave
	get_tree().paused = true

func game_completed():
	%GameOverScreen.visible = true
	%GameOverTitle.text = "Success !"
	%ScoreLabel.text = "You've completed this map and survided :\n %s" % current_wave
	%Confetti.play_confetti()
	get_tree().paused = true

func _on_spawn_enemy_timer_timeout():
		spawn_mob()

func _on_spawn_flying_enemy_timer_timeout():
	if Global.selected_difficulty == 4:
		spawn_flying_mob()

func _on_restart_button_pressed():
	print("replay !")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_core_core_destroyed():
	game_over()


func _on_audio_stream_player_finished():
	%BackgroundAudioPlayer.play()


func _on_transition_layer_transition_is_finished(anim_name):
	if anim_name == "close_transition":
		get_tree().change_scene_to_file("res://GameElements/Screens/welcome_screen.tscn")


func _on_options_menu_audio_value_changed():
	%BackgroundAudioPlayer.volume_db = Global.audio_volume


func _on_quit_to_menu_pressed():
	Global.save_game()
	get_tree().call_group("has_static_properties", "_reinitialize_static_properties")
	get_tree().paused = false
	get_node("/root/Game/TransitionLayer").close_transition()
