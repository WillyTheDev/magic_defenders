class_name Player
extends CharacterBody2D

@export var starting_mana_amount = 0
var mana_amount = 0
@export var screen_size = Vector2i(0,0)
static var accumulated_mana = 0
static var level = 1
static var offset_accumulated_mana_value = 10
var player_damage = 1
var player_speed = 300
var is_building = false

signal player_update_mana_amount
signal show_cards

func _ready():
	screen_size = get_parent().get_node("MapLimit").global_position
	get_node("/root/Game/CardsManager").player_modified.connect(_on_player_modified)
	update_mana_amount(starting_mana_amount, true)

func _on_player_modified(args):
	args.call(self)

func update_mana_amount(mana: int, acquire: bool):
	mana_amount += mana
	print("Update mana Label")
	player_update_mana_amount.emit(mana_amount)
	if acquire:
		%ManaAudio.play()
		accumulated_mana += mana
		if accumulated_mana >= (offset_accumulated_mana_value + ( level * 10 )):
			accumulated_mana -= (offset_accumulated_mana_value + ( level * 10 ))
			level += 1
			show_cards.emit()

func _physics_process(delta):
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * player_speed
	move_and_slide()
	if velocity.length() > 0.0:
		if %WalkAudio.playing == false:
			%WalkAudio.playing = true
		%PlayerAnimation.play_animation_walk();
	else:
		%PlayerAnimation.play_animation_idle();
		%WalkAudio.playing = false

func _input(event):
	if event.is_action_pressed("left_click"):
		if is_building:
			_place_defense()
		else:
			%AutoShootTimer.start()
			_shoot()
	if event.is_action_released("left_click"):
			%AutoShootTimer.stop()
	if event.is_action_pressed("turret_key_pressed"):
		if is_building == false:
			_on_turret_button_pressed()
	if event.is_action_pressed("defense_key_pressed"):
		if is_building == false:
			_on_defense_button_pressed()
		

func _shoot():
	print("shoot")
	%FireAudio.play()
	const FIRE_BOLT = preload("res://GameElements/Player/fire_bolt.tscn")
	var new_fire_bolt = FIRE_BOLT.instantiate()
	new_fire_bolt.global_position = %ShootingPoint.global_position
	new_fire_bolt.global_rotation = %ShootingPoint.global_rotation
	new_fire_bolt.damage = player_damage
	new_fire_bolt.direction = (%ShootingPoint.global_position - get_global_mouse_position()).normalized() * -1
	get_parent().add_child(new_fire_bolt)

func _place_defense():
	%PlaceDefenseAudio.play()
	print("Place defense !")
	is_building = false	

func _on_defense_button_pressed():
	var defense_price = Defense.defense_price
	if mana_amount >= defense_price:
		update_mana_amount(-defense_price, false)
		is_building = true
		const DEFENSE = preload("res://GameElements/defense/defense.tscn")
		var new_defense = DEFENSE.instantiate()
		new_defense.global_position = get_global_mouse_position()
		new_defense.rotation = get_angle_to(get_global_mouse_position())
		get_parent().add_child(new_defense)


func _on_turret_button_pressed():
	var turret_price = Turret.turret_price
	if mana_amount >= turret_price:
		update_mana_amount(-turret_price, false)
		is_building = true
		const TURRET = preload("res://GameElements/defense/turret.tscn")
		var new_turret = TURRET.instantiate()
		new_turret.global_position = get_global_mouse_position()
		new_turret.rotation = get_angle_to(get_global_mouse_position())
		get_parent().add_child(new_turret)


func _on_auto_shoot_timer_timeout():
	_shoot()
