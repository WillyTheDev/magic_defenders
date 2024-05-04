class_name Defense
extends Node2D

@export var health = 4
@export var has_been_build = false

var cumulated_damage = 0

signal defense_destroyed()

func abstract_final_action():
	assert("This class is not derived from Defense !")
	
func abstract_on_body_exited_defense_zone():
	assert("This class is not derived from Defense !")
	
func abstract_on_process():
	assert("This class is not derived from Defense !")

func _process(float):
	abstract_on_process()
	if has_been_build == false:
		global_position = get_global_mouse_position()
		rotation = get_node("/root/Game/Player").get_angle_to(get_global_mouse_position())
	
func _input(event):
	if event.is_action_pressed("left_click"):
		if has_been_build == false:
			modulate = "ffffff"
			%StaticBody2D.collision_layer = 1
			%StaticBody2D.collision_mask = 1
			%Area2D.collision_layer = 1
			%Area2D.collision_mask = 1
			has_been_build = true



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
	
func _on_area_2d_body_exited(body: Enemy):
	cumulated_damage -= 1
	abstract_on_body_exited_defense_zone()

func _on_timer_timeout():
	take_damage()
