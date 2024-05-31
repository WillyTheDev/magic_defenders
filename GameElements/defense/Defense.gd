class_name Defense
extends Node2D


static var defense_price = 10
@export var has_been_build = false
@export var can_be_placed = true

@export var current_health = 10.0
var cumulated_damage = 0

func _reinitialize_static_properties():
	defense_price = 10

func heal_defense(amount):
	current_health = clamp(amount, 0,Global.getDefenseHealth())
	var values = (255 * (current_health/Global.getDefenseHealth()))
	modulate = "ff%x%xff" % [values, values]

func _ready():
	add_to_group("has_static_properties")
	var DefenseTimer = get_node("/root/Game/DefenseTimer")
	DefenseTimer.timeout.connect(_on_timer_timeout)
	current_health += Global.getDefenseHealth()
	
func _apply_modification(args: Callable):
	args.call(self)
		

func abstract_final_action():
	pass
	
func abstract_on_body_exited_defense_zone():
	pass
	
func abstract_on_process():
	pass
	
func abstract_build_defense():
	pass

func abstract_defense_take_damage():
	pass

func abstract_input(_event):
	pass

	
func build_defense():
	#Place and fix the defense at the determined position and reset the modulate and collision_layer
	modulate = "ffffff"
	%StaticBody2D.collision_layer = 1
	%StaticBody2D.collision_mask = 1
	%Area2D.collision_layer = 1
	%Area2D.collision_mask = 1
	abstract_build_defense()
	has_been_build = true

func _process(_float):
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
	abstract_input(event)
	if event.is_action_pressed("left_click"):
		if has_been_build == false && can_be_placed == true:
			build_defense()



func take_damage():
	if cumulated_damage > 0:
		abstract_defense_take_damage()
		current_health -= cumulated_damage
		if current_health <= 0:
			abstract_final_action()
			const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
			var new_smoke = SMOKE.instantiate()
			new_smoke.global_position = global_position
			get_parent().add_child(new_smoke)
			queue_free()
		else:
			var values = (255 * (current_health/(10+Global.getDefenseHealth())))
			modulate = "ff%x%xff" % [values, values]

func _on_area_2d_body_entered(body):
	if body is Enemy:
		body.speed = 0
		cumulated_damage += body.enemy_damage
	
func _on_area_2d_body_exited(body):
	if body is Enemy:
		cumulated_damage -= body.enemy_damage
		body.reset_speed()
		abstract_on_body_exited_defense_zone()

func _on_timer_timeout():
	take_damage()
