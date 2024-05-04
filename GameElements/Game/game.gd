extends Node2D

var mana_amount = 0
@export var paths: Array[Path2D] = []

func _on_slime_killed(mana):
	mana_amount += mana

func spawn_mob():
	var mob = preload("res://GameElements/Ennemies/Enemy.tscn").instantiate()
	mob.get_node("Slime").reward_player.connect(_on_slime_killed)
	var indexSpawnPoints = randf() * paths.size()
	paths[indexSpawnPoints].add_child(mob)

func _on_timer_timeout():
	spawn_mob()
	
	
	

	
