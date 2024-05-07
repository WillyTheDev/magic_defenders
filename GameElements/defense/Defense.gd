class_name Defense
extends Node2D

@export var total_health : float = 4.0
@export var has_been_build = false
@export var can_be_placed = true

@onready var shader = preload("res://Shaders/sokpop.gdshader")
@onready var texture = preload("res://Shaders/normal.jpg")


var current_health = 4.0
var cumulated_damage = 0

signal defense_destroyed()

func _ready():
	current_health = total_health

func abstract_final_action():
	assert("This class is not derived from Defense !")
	
func abstract_on_body_exited_defense_zone():
	assert("This class is not derived from Defense !")
	
func abstract_on_process():
	assert("This class is not derived from Defense !")
	
func abstract_build_defense():
	assert("This class is not derived from Defense !")
	
func build_defense():
	#Place and fix the defense at the determined position and reset the modulate and collision_layer
	modulate = "ffffff"
	%StaticBody2D.collision_layer = 1
	%StaticBody2D.collision_mask = 1
	%Area2D.collision_layer = 1
	%Area2D.collision_mask = 1
	abstract_build_defense()
	has_been_build = true

func _process(float):
	abstract_on_process()
	if has_been_build == false:
		global_position = get_global_mouse_position()
		rotation = get_node("/root/Game/Player").get_angle_to(get_global_mouse_position())
		if %Area2D.get_overlapping_bodies().size() > 0 :
			can_be_placed = false
			#Set the modulate color to red
			modulate = "eb002b8b"
		else :
			can_be_placed = true
			#Set the modulate color to green
			modulate = "2398008b"
		
	
func _input(event):
	if event.is_action_pressed("left_click"):
		if has_been_build == false && can_be_placed == true:
			build_defense()



func take_damage():
	current_health -= cumulated_damage
	if current_health <= 0:
		abstract_final_action()
		defense_destroyed.emit()
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		new_smoke.global_position = global_position
		get_parent().add_child(new_smoke)
		queue_free()
	else:
		var values = (255 * (current_health/total_health))
		modulate = "ff%x%xff" % [values, values]

func _on_area_2d_body_entered(body):
	if body is Enemy:
		defense_destroyed.connect(body.no_longer_attacking_defense)
		body.speed = 0
		cumulated_damage += body.damage
		if %Timer.is_stopped():
			%Timer.start()
	
func _on_area_2d_body_exited(body):
	if body is Enemy:
		cumulated_damage -= body.damage
		abstract_on_body_exited_defense_zone()

func _on_timer_timeout():
	take_damage()
