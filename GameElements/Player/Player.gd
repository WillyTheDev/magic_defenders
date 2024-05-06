class_name Player
extends CharacterBody2D

@export var mana_amount = 40
@export var screen_size = Vector2i(0,0)
var is_building = false
signal player_update_mana_amount

func _ready():
	screen_size = get_parent().get_node("MapLimit").global_position

func update_mana_amount(mana: int):
	mana_amount += mana
	player_update_mana_amount.emit(mana_amount)

func _physics_process(delta):
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
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
	var defense_price = get_parent().defense_price
	if mana_amount >= defense_price:
		update_mana_amount(-defense_price)
		is_building = true
		const DEFENSE = preload("res://GameElements/defense/defense.tscn")
		var new_defense = DEFENSE.instantiate()
		new_defense.global_position = get_global_mouse_position()
		new_defense.rotation = get_angle_to(get_global_mouse_position())
		get_parent().add_child(new_defense)


func _on_turrent_button_pressed():
	var turret_price = get_parent().turret_price
	if mana_amount >= turret_price:
		update_mana_amount(-turret_price)
		is_building = true
		const TURRET = preload("res://GameElements/defense/turret.tscn")
		var new_turret = TURRET.instantiate()
		new_turret.global_position = get_global_mouse_position()
		new_turret.rotation = get_angle_to(get_global_mouse_position())
		get_parent().add_child(new_turret)
