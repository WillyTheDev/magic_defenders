class_name Game
extends Node2D

var increments_nb_enemies_per_wave = 8
var spawn_rates = 2
var spawn_flying_enemy_rates = 20

static var is_idle = true
static var is_on_hub = false
var map_of_game = Map
var paths: Array[Path2D] = []
var options_menu_open = false
var max_wave : float = 30.0
#Those variables are used to know which ennemy to spawn
static var current_wave : float = 0.0


var is_spawning = true
static var game_is_over = true

signal wave_is_over
signal on_game_is_over

var sequence_enemies = {
	"slime_normale" : 0,
	"slime_medium" : 0,
	"slime_hard": 0,
	"bat": 0,
	"slime_mana": 0
}

# Use the _ready methode to reinitialize static properties from various classes
func _ready():
	Player.mana_amount = 0
	current_wave = Global.starting_wave
	is_idle = true
	map_of_game = load("res://GameElements/Maps/map_%s.tscn" % Global.selected_map).instantiate()
	add_child(map_of_game)
	get_node("Map/Core").core_destroyed.connect(_on_core_destroyed)
	%Spawner.map_of_game = map_of_game
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
	Spawner.sequence_index += 1
	Spawner.total_enemies = 0
	var index = 0
	if Global.selected_difficulty < 4:
		while index != map_of_game.sequences[Spawner.sequence_index].size():
			var value = map_of_game.sequences[Spawner.sequence_index][index]
			var type = map_of_game.sequences[Spawner.sequence_index][index + 1]
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
			Spawner.total_enemies += value
			index += 2
		Spawner.number_of_time = map_of_game.sequences[Spawner.sequence_index][0]
		Spawner.type_of_enemy = map_of_game.sequences[Spawner.sequence_index][1]
	else :
		Spawner.total_enemies = current_wave * 8
	Spawner.enemies_spawn = 0
	Spawner.spawn_index = 0
	Spawner.enemies_left = Spawner.total_enemies
	#Update the UI accordingly
	%EnemiesProgressBar.max_value = Spawner.total_enemies
	%EnemiesProgressBar.value = Spawner.total_enemies
	%EnemiesLabel.text = "Wave %s : %s / %s" % [current_wave, Spawner.enemies_left, Spawner.total_enemies]
	%WaveActionLabel.visible = false
	#Start the Spawning timers
	%SpawnEnemyTimer.wait_time = clamp(spawn_rates, 0.5, 2.5)
	%SpawnEnemyTimer.start()
	%SpawnFlyingEnemyTimer.wait_time = clamp(spawn_flying_enemy_rates, 0.5, 2.5)
	%SpawnFlyingEnemyTimer.start()
	if (current_wave > 5 && Global.selected_difficulty > 1) || Global.selected_difficulty == 99:
		Enemy.base_health += 1
		Enemy.base_speed += 1
		if Global.selected_difficulty > 2:
			Enemy.base_damage += 1

func end_of_wave():
	%Enemy_1.visible = false
	%Enemy_2.visible = false
	%Enemy_3.visible = false
	%Enemy_4.visible = false
	%Enemy_5.visible = false
	%Enemy_6.visible = false
	%Enemy_7.visible = false
	%WaveLAbel.text = "Wave : %s Cleared !" % current_wave
	%UI.show_next_wave_label()
	%Confetti.play_confetti()
	%SpawnEnemyTimer.stop()
	%SpawnFlyingEnemyTimer.stop()
	%EnemiesLabel.text = ""
	%WaveActionLabel.visible = true
	# Give stars base on the current_wave
	if current_wave == map_of_game.sequences.size():
		on_game_is_over.emit()
		%GameOverScreen.game_completed(current_wave, 3, map_of_game)
	is_idle = true
	wave_is_over.emit()

func _input(event):
	if event.is_action_pressed("action_button"):
		if is_idle && map_of_game.is_hub == false && %GameOverScreen.game_is_over == false:
			start_new_wave()

func _on_player_player_update_mana_amount(mana):
	%ManaLabel.text = "Mana : %s" % mana
	%SkillContainer.update_progress_bar()
	%AccumulatedManaLabel.text = "%s / %s until the next level" % [Global.accumulated_mana, (Player.offset_accumulated_mana_value + Global.player_level * 10)]
	%AccumulatedMana.max_value = Player.offset_accumulated_mana_value + Global.player_level * 10
	%AccumulatedMana.value = Player.accumulated_mana


func _on_core_destroyed(value):
	print("Game emit() on game is over !")
	on_game_is_over.emit()
	%GameOverScreen.game_over(current_wave)

func _on_audio_stream_player_finished():
	%BackgroundAudioPlayer.play()

func _show_new_hat_animation(hat_index : int):
	%NewHatTexture.texture = load("res://Assets/hats/hat_%s.png" % hat_index)
	%UI/UIAnimationPlayer.queue("show_new_hat")
	
