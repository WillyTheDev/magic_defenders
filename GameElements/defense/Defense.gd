class_name Defense
extends Node2D

@export var health = 4
var cumulated_damage = 0

signal defense_destroyed()

func abstract_final_action():
	assert("This class is not derived from Defense !")

func take_damage():
	health -= cumulated_damage
	if health <= 0:
		abstract_final_action()
		defense_destroyed.emit()
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		new_smoke.global_position = global_position
		get_parent().add_child(new_smoke)
		queue_free()

func _on_area_2d_body_entered(body: Enemy):
	defense_destroyed.connect(body.no_longer_attacking_defense)
	body.speed = 0
	cumulated_damage += 1
	if %Timer.is_stopped():
		%Timer.start()
	




func _on_timer_timeout():
	take_damage()
	
