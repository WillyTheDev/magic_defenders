extends Node2D

var mana_amount = 0

func _on_slime_killed(mana):
	mana_amount += mana

func spawn_mob():
	var mob = preload("res://GameElements/Ennemies/slime.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf() * 100
	mob.global_position = %PathFollow2D.global_position
	add_child(mob)
	mob.reward_player.connect(_on_slime_killed)

func _on_timer_timeout():
	spawn_mob()
	
	
	

	
