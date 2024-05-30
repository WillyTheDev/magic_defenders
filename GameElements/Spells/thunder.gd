extends Node2D

var has_enemy = false

func _ready():
	%Timer.wait_time = Global.getDefenseFireRate() * 2
	scale = Vector2(3 * Global.getDefenseRange(),3 * Global.getDefenseRange())

func _shoot(body):
	var strike = preload("res://GameElements/Skills/thunderStrike.tscn").instantiate()
	strike.global_position = (body.global_position + Vector2(0,-488))
	$/root/Game.add_child(strike)
	body.take_damage(2 + Global.getPlayerDamage() / 2)

func _on_timer_timeout():
	var ennemies = []
	for body in %Area2D.get_overlapping_bodies():
		if body is Enemy:
			ennemies.append(body)
	if ennemies.size() > 0:
		_shoot(ennemies[randi_range(0, ennemies.size() - 1)])
