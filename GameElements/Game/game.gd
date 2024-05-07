extends Node2D

@export var defense_price = 10
@export var turret_price = 20
@export var paths: Array[Path2D] = []
@export var max_wave = 30
@export var current_wave = 0
@export var total_enemies = 10
@export var enemies_spawn = 0
@export var enemies_left = 10
@export var spawn_rates = 1.8
@export var is_idle = true
	

func start_new_wave():
	is_idle = false
	spawn_rates -= 0.5
	current_wave += 1
	total_enemies = current_wave * 10
	enemies_left = total_enemies
	enemies_spawn = 0
	#Update the UI accordingly
	%EnemiesProgressBar.max_value = total_enemies
	%EnemiesProgressBar.value = total_enemies
	%EnemiesLabel.text = "Wave %s : %s / %s" % [current_wave, enemies_left, total_enemies]
	%WaveActionLabel.visible = false
	%SpawnEnemyTimer.wait_time = spawn_rates
	%SpawnEnemyTimer.start()

func end_of_wave():
	%SpawnEnemyTimer.stop()
	%EnemiesLabel.text = ""
	%WaveActionLabel.visible = true
	is_idle = true

func spawn_mob():
	enemies_spawn += 1
	var mob = preload("res://GameElements/Enemies/Enemy.tscn").instantiate()
	var indicator = preload("res://GameElements/misc/enemy_indicator.tscn").instantiate()
	mob.get_node("Slime").slime_has_been_killed.connect(on_enemy_has_been_killed)
	var indexSpawnPoints = floor(randf() * paths.size())
	paths[indexSpawnPoints].add_child(mob)
	indicator.target = mob.get_node("Slime")
	%Player.add_child(indicator)
	
func game_over():
	%GameOverScreen.visible = true
	
func on_enemy_has_been_killed():
	enemies_left -= 1
	%EnemiesProgressBar.value = enemies_left
	%EnemiesLabel.text = "%s / %s" % [enemies_left, total_enemies]
	if enemies_left <= 0:
		end_of_wave()

	
func _on_player_player_update_mana_amount(mana):
	%ManaLabel.text = "Mana : %s" % mana

func _input(event):
	if event.is_action_pressed("action_button"):
		if is_idle:
			start_new_wave()

func _on_spawn_enemy_timer_timeout():
	if enemies_spawn < total_enemies:
		spawn_mob()


func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_core_core_destroyed():
	game_over()
