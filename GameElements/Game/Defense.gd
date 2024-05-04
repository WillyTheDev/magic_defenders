extends Node2D

var health = 4
var cumulated_damage = 0

signal defense_destroyed()

func take_damage():
	print("defense is taking damage ! health : %s" % health)
	health -= cumulated_damage
	if health <= 0:
		defense_destroyed.emit()
		queue_free()

func _on_area_2d_body_entered(body: Follower):
	defense_destroyed.connect(body.no_longer_attacking_defense)
	body.speed = 0
	cumulated_damage += 1
	if %Timer.is_stopped():
		%Timer.start()
	




func _on_timer_timeout():
	take_damage()
	
