extends Node2D

@export var defense_price = 10
@export var turret_price = 20
@export var paths: Array[Path2D] = []
@export var max_wave = 30
@export var current_wave = 0
@export var total_enemies = 10
@export var enemies_left = 10
@export var spawn_rates = 1.8

func _ready():
	start_new_wave()
	


func start_new_wave():
	spawn_rates -= 0.5
	current_wave += 1
	total_enemies = current_wave * 10
	enemies_left = total_enemies
	%EnemiesProgressBar.max_value = total_enemies
	%EnemiesProgressBar.value = total_enemies
	%EnemiesLabel.text = "%s / %s" % [enemies_left, total_enemies]
	%SpawnEnemyTimer.wait_time = spawn_rates
	%SpawnEnemyTimer.start()

func spawn_mob():
	var mob = preload("res://GameElements/Enemies/Enemy.tscn").instantiate()
	mob.get_node("Slime").slime_has_been_killed.connect(on_enemy_has_been_killed)
	var indexSpawnPoints = floor(randf() * paths.size())
	paths[indexSpawnPoints].add_child(mob)
	
func on_enemy_has_been_killed():
	enemies_left -= 1
	%EnemiesProgressBar.value = enemies_left
	%EnemiesLabel.text = "%s / %s" % [enemies_left, total_enemies]
	if enemies_left <= 0:
		start_new_wave()
	
	
func _on_player_player_update_mana_amount(mana):
	%ManaLabel.text = "Mana : %s" % mana


func _on_spawn_enemy_timer_timeout():
	spawn_mob()
