extends CharacterBody2D

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 300
	move_and_slide()
	if velocity.length() > 0.0:
		%PlayerAnimation.play_animation_walk();
	else:
		%PlayerAnimation.play_animation_idle();

func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		shoot()

func shoot():
	const FIRE_BOLT = preload("res://GameElements/Player/fire_bolt.tscn")
	var new_fire_bolt = FIRE_BOLT.instantiate()
	new_fire_bolt.global_position = %ShootingPoint.global_position
	new_fire_bolt.global_rotation = %ShootingPoint.global_rotation
	
	new_fire_bolt.direction = (global_position - get_global_mouse_position()).normalized() * -1
	get_parent().add_child(new_fire_bolt)
