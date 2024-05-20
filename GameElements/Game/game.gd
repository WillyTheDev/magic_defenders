class_name Game
extends Node2D

@export var total_enemies = 10
@export var increments_nb_enemies_per_wave = 8
@export var enemies_spawn = 0
@export var enemies_left = 10
@export var spawn_rates = 2
@export var spawn_flying_enemy_rates = 20

static var is_idle = true

var map_of_game = Map
var paths: Array[Path2D] = []
var options_menu_open = false
var max_wave : float = 30.0
var current_wave : float = 0.0

signal wave_is_over

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
	max_wave = map_of_game.difficulty
	%TransitionLayer.open_transition()
	%BackgroundAudioPlayer.volume_db = Global.audio_volume
	

func start_new_wave():
	is_idle = false
	spawn_rates -= 0.2
	spawn_flying_enemy_rates -= 0.2
	current_wave += 1
	total_enemies = current_wave * increments_nb_enemies_per_wave
	enemies_left = total_enemies
	enemies_spawn = 0
	#Update the UI accordingly
	%EnemiesProgressBar.max_value = total_enemies
	%EnemiesProgressBar.value = total_enemies
	%EnemiesLabel.text = "Wave %s : %s / %s" % [current_wave, enemies_left, total_enemies]
	%WaveActionLabel.visible = false
	%SpawnEnemyTimer.wait_time = clamp(spawn_rates, 1, 2.5)
	%SpawnEnemyTimer.start()
	%SpawnFlyingEnemyTimer.wait_time = spawn_flying_enemy_rates
	%SpawnFlyingEnemyTimer.start()
	
	if current_wave >= 5:
		Enemy.base_health += map_of_game.enemy_health_increment

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
	print(map_of_game.min_wave_star_3)
	print(map_of_game.min_wave_star_2)
	print(map_of_game.min_wave_star_1)
	match current_wave:
		map_of_game.min_wave_star_3:
			%StarAnimation.play("show_second_star")
			if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 3:
				Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 3.0
				Global.accumulated_stars += 1
				%StarAnimation.play("show_third_star")
		map_of_game.min_wave_star_2:
			%StarAnimation.play("show_second_star")
			if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 2:
				Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 2.0
				Global.accumulated_stars += 1
		map_of_game.min_wave_star_1:
			%StarAnimation.play("show_first_star")
			if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 1:
				Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 1.0
				Global.accumulated_stars += 1
				
		var other:
			print("current wave is %s" % other)
	is_idle = true
	wave_is_over.emit()

func spawn_flying_mob():
	if current_wave > map_of_game.flying_enemy_start_wave:
		enemies_spawn += 1
		var flying_enemy = preload("res://GameElements/Enemies/Slime/bat.tscn").instantiate()
		map_of_game.flyingSpawnPoint.progress_ratio = randf()
		flying_enemy.global_position = map_of_game.flyingSpawnPoint.global_position
		flying_enemy.slime_has_been_killed.connect(on_enemy_has_been_killed)
		add_child(flying_enemy)
		spawn_visual_indicator(flying_enemy)

func spawn_mob():
	enemies_spawn += 1
	#Load a new Enemy ( Path2DFollower ) and attach the relevent monster ( e.g slime, slimeMedium, archer...)
	var enemy = preload("res://GameElements/Enemies/Enemy.tscn").instantiate()
	var slime = null
	var enemy_spawn_chance : float = randf()
	var medium_enemy_spawn_chance: float = (current_wave)/(map_of_game.difficulty * 2)
	var hard_enemy_spawn_chance :float =  current_wave/(map_of_game.difficulty * 10)
	var mana_enemy_spawn_chance : float = 0.005
	if (enemy_spawn_chance < hard_enemy_spawn_chance) && current_wave > map_of_game.hard_enemy_start_wave:
		slime = preload("res://GameElements/Enemies/Slime/slime_hard.tscn").instantiate()
	elif (enemy_spawn_chance < medium_enemy_spawn_chance) && current_wave > map_of_game.medium_enemy_start_wave:
		slime = preload("res://GameElements/Enemies/Slime/slime_medium.tscn").instantiate()
	elif enemy_spawn_chance > 1 - mana_enemy_spawn_chance:
		slime = preload("res://GameElements/Enemies/Slime/slime_mana.tscn").instantiate()
	else:
		slime = preload("res://GameElements/Enemies/Slime/slime.tscn").instantiate()
	slime.slime_has_been_killed.connect(on_enemy_has_been_killed)
	enemy.add_child(slime)
	# Add the Enemy on a random path
	var indexSpawnPoints = floor(randf() * map_of_game.paths.size())
	map_of_game.paths[indexSpawnPoints].add_child(enemy)
	spawn_visual_indicator(enemy.get_node("Slime"))
	
func spawn_visual_indicator(target):
	# Add a visual indicator for each Enemy spawned
	var indicator = preload("res://GameElements/misc/enemy_indicator.tscn").instantiate()
	indicator.target = target
	indicator.global_position = get_node("Player").global_position
	get_node("Player").add_child(indicator)
	
func game_over():
	%GameOverScreen.visible = true
	%ScoreLabel.text = "The lotus has been destroyed\n %s waves" % current_wave
	get_tree().paused = true
	
func on_enemy_has_been_killed():
	enemies_left -= 1
	%EnemiesProgressBar.value = enemies_left
	%EnemiesLabel.text = "%s / %s" % [enemies_left, total_enemies]
	if enemies_left <= 0 && enemies_spawn == total_enemies:
		end_of_wave()



func _input(event):
	if event.is_action_pressed("action_button"):
		if is_idle:
			start_new_wave()



func _on_player_player_update_mana_amount(mana):
	%ManaLabel.text = "Mana : %s" % mana
	print(mana)
	%TurretButton/ProgressBarBackground.value = 20 - mana
	%DefenseButton/ProgressBarBackground.value = 10 - mana
	%MeteorButton/ProgressBarBackground.value = 60 - mana
	%AccumulatedManaLabel.text = "%s / %s until the next level" % [Global.accumulated_mana, (Player.offset_accumulated_mana_value + Global.player_level * 10)]
	%AccumulatedMana.max_value = Player.offset_accumulated_mana_value + Global.player_level * 10
	%AccumulatedMana.value = Player.accumulated_mana

func _on_spawn_enemy_timer_timeout():
	if enemies_spawn < total_enemies:
		print("Spawning")
		spawn_mob()

func _on_spawn_flying_enemy_timer_timeout():
	print("Flying : %s / %s" % [enemies_spawn, total_enemies])
	if enemies_spawn < total_enemies:
		print("Spawning")
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
