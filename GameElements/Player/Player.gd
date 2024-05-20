class_name Player
extends CharacterBody2D

@export var starting_mana_amount = 60
@export var points_per_level = 1
var mana_amount = 0
@export var screen_size = Vector2i(0,0)
static var accumulated_mana = 0
static var offset_accumulated_mana_value = 10

var player_speed = 300
var big_shoot_damage = 50
var big_shoot_price = 60
var is_building = false

signal player_update_mana_amount
signal show_cards

func _ready():
	var playerManager = get_node("/root/Game/PlayerManager")
	var optionMenu = get_node("/root/Game/OptionsMenu")
	optionMenu.sound_value_changed.connect(_update_sound_volume)
	playerManager.apply_hat()
	screen_size = get_node("/root/Game/Map/MapLimit").global_position
	_update_sound_volume()
	update_mana_amount(starting_mana_amount, false)

func _update_sound_volume():
	%WalkAudio.volume_db = Global.sound_volume
	%PlaceDefenseAudio.volume_db = Global.sound_volume
	%FireAudio.volume_db = Global.sound_volume
	%ManaAudio.volume_db = Global.sound_volume

func update_mana_amount(mana: int, acquire: bool):
	mana_amount += mana
	print("Update mana Label")
	player_update_mana_amount.emit(mana_amount)
	if acquire:
		%ManaAudio.play()
		Global.accumulated_mana += mana
		if Global.accumulated_mana >= (offset_accumulated_mana_value + ( Global.player_level * 10 )):
			%PlayerAnimation.play_animation_levelup()
			print("Level up 🐸")
			Global.accumulated_mana -= (offset_accumulated_mana_value + ( Global.player_level * 10 ))
			Global.player_level += 1
			Global.player_avail_pts = points_per_level
			var confetti = get_node("/root/Game/Confetti") 
			var player_manager : PlayerManager = get_node("/root/Game/PlayerManager")

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
	if event.is_action_pressed("right_click"):
		_bigShoot()



func _bigShoot():
	if mana_amount >= big_shoot_price:
		update_mana_amount(-big_shoot_price, false)
		const METEOR_BOLT = preload("res://GameElements/Player/meteor_bolt.tscn")
		var explosion = preload("res://GameElements/misc/explosion_sound.tscn").instantiate()
		var new_meteor_bolt = METEOR_BOLT.instantiate()
		explosion.global_position = get_global_mouse_position()
		new_meteor_bolt.global_position = get_global_mouse_position()
		new_meteor_bolt.damage = big_shoot_damage
		get_parent().add_child(new_meteor_bolt)
		get_parent().add_child(explosion)


func _shoot():
	%FireAudio.play()
	print(Global.getPlayerDamage())
	const FIRE_BOLT = preload("res://GameElements/Player/fire_bolt.tscn")
	var new_fire_bolt = FIRE_BOLT.instantiate()
	new_fire_bolt.global_position = %ShootingPoint.global_position
	new_fire_bolt.global_rotation = %ShootingPoint.global_rotation
	new_fire_bolt.damage = Global.getPlayerDamage()
	new_fire_bolt.direction = (%ShootingPoint.global_position - get_global_mouse_position()).normalized() * -1
	get_parent().add_child(new_fire_bolt)

func _place_defense():
	%PlaceDefenseAudio.play()
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
