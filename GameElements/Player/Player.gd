extends CharacterBody2D

var is_building = false

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 300
	move_and_slide()
	if velocity.length() > 0.0:
		%PlayerAnimation.play_animation_walk();
	else:
		%PlayerAnimation.play_animation_idle();

func _input(event):
	if event.is_action_pressed("left_click"):
		if is_building:
			place_defense()
		else:
			shoot()
		

func shoot():
	const FIRE_BOLT = preload("res://GameElements/Player/fire_bolt.tscn")
	var new_fire_bolt = FIRE_BOLT.instantiate()
	new_fire_bolt.global_position = %ShootingPoint.global_position
	new_fire_bolt.global_rotation = %ShootingPoint.global_rotation
	new_fire_bolt.direction = (global_position - get_global_mouse_position()).normalized() * -1
	get_parent().add_child(new_fire_bolt)

func place_defense():
	is_building = false

func _on_defense_button_pressed():
	is_building = true
	const DEFENSE = preload("res://GameElements/defense/defense.tscn")
	var new_defense = DEFENSE.instantiate()
	new_defense.global_position = get_global_mouse_position()
	new_defense.rotation = get_angle_to(get_global_mouse_position())
	get_parent().add_child(new_defense)


func _on_turrent_button_pressed():
	is_building = true
	const TURRET = preload("res://GameElements/defense/turret.tscn")
	var new_turret = TURRET.instantiate()
	new_turret.global_position = get_global_mouse_position()
	new_turret.rotation = get_angle_to(get_global_mouse_position())
	get_parent().add_child(new_turret)
