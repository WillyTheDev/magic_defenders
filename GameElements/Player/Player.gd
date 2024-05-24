class_name Player
extends CharacterBody2D

var starting_mana_amount = 30
@export var points_per_level = 1
var mana_amount = 0
@export var screen_size = Vector2i(0,0)
static var accumulated_mana = 0
static var offset_accumulated_mana_value = 10
static var base_ammo = 10
var ammo = 10
var player_speed = 300
var big_shoot_damage = 50
var big_shoot_price = 60
var defense_to_be_placed : Node2D = null
var defense_to_be_placed_type : String = ''
var is_building = false

signal player_has_level_up
signal player_update_mana_amount
signal show_cards
signal player_has_shoot
signal player_got_new_hat

static var magic_bolt = null

func _ready():
	var playerManager = get_node("/root/Game/PlayerManager")
	var optionMenu = get_node("/root/Game/OptionsMenu")
	optionMenu.sound_value_changed.connect(_update_sound_volume)
	var uiMenu = get_node("/root/Game/UI")
	player_has_level_up.connect(uiMenu.show_available_point)
	playerManager.apply_hat()
	screen_size = get_node("/root/Game/Map/MapLimit").global_position
	_update_sound_volume()
	update_mana_amount(starting_mana_amount, false)
	magic_bolt = preload("res://GameElements/Spells/magic_bolt.tscn")

func _update_sound_volume():
	%WalkAudio.volume_db = Global.sound_volume
	%PlaceDefenseAudio.volume_db = Global.sound_volume
	%FireAudio.volume_db = Global.sound_volume
	%ManaAudio.volume_db = Global.sound_volume

func update_mana_amount(mana: int, acquire: bool):
	mana_amount += mana
	player_update_mana_amount.emit(mana_amount)
	if acquire:
		%ManaAudio.play()
		Global.accumulated_mana += mana
		if Global.accumulated_mana >= (offset_accumulated_mana_value + ( Global.player_level * 10 )):
			%PlayerAnimation.play_animation_levelup()
			Global.accumulated_mana -= (offset_accumulated_mana_value + ( Global.player_level * 10 ))
			Global.player_level += 1
			Global.player_avail_pts += points_per_level
			player_has_level_up.emit()
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
			print("PLACE BUILDING")
			_place_defense()
		else:
			if ammo > 0:
				%AutoShootTimer.start()
				_shoot()
			else:
				_reload()
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
	if event.is_action_pressed("show_options"):
		if is_building && defense_to_be_placed != null:
			defense_to_be_placed_type
			defense_to_be_placed.queue_free()
			if defense_to_be_placed_type == 'turret':
				update_mana_amount(Turret.turret_price, false)
			else:
				update_mana_amount(Defense.defense_price, false)
	if event.is_action_released("show_options"):
		is_building = false
	if event.is_action_pressed("reload"):
		_reload()
			



func _bigShoot():
	if mana_amount >= big_shoot_price:
		update_mana_amount(-big_shoot_price, false)
		const METEOR_BOLT = preload("res://GameElements/Spells/meteor_bolt.tscn")
		var explosion = preload("res://GameElements/misc/explosion_sound.tscn").instantiate()
		var new_meteor_bolt = METEOR_BOLT.instantiate()
		explosion.global_position = get_global_mouse_position()
		new_meteor_bolt.global_position = get_global_mouse_position()
		new_meteor_bolt.damage = big_shoot_damage
		get_parent().add_child(new_meteor_bolt)
		get_parent().add_child(explosion)

func _reload():
	if %ReloadTimer.is_stopped():
		%ReloadAnimation.play("reload")
		%ReloadTimer.start()

func _shoot():
	%FireAudio.play()
	var new_magic_bolt = magic_bolt.instantiate()
	new_magic_bolt.global_position = %ShootingPoint.global_position
	new_magic_bolt.global_rotation = %ShootingPoint.global_rotation
	new_magic_bolt.damage = Global.getPlayerDamage()
	var direction = (%ShootingPoint.global_position - get_global_mouse_position()).normalized() * -1
	velocity = direction * -1
	new_magic_bolt.direction = direction
	get_parent().add_child(new_magic_bolt)
	ammo -= 1
	player_has_shoot.emit(ammo)

func _place_defense():
	if(defense_to_be_placed.can_be_placed):
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
		defense_to_be_placed = new_defense
		defense_to_be_placed_type = 'defense'
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
		defense_to_be_placed = new_turret
		defense_to_be_placed_type = 'turret'
		get_parent().add_child(new_turret)


func _on_reload_timer_timeout():
	ammo = base_ammo
	player_has_shoot.emit(ammo)
	
func _on_auto_shoot_timer_timeout():
	if ammo > 0:
		_shoot()
	elif %ReloadTimer.is_stopped():
		_reload()
		
func get_new_hat(index : int):
	get_parent()
	Global.unlocked_hats[index] = true
	player_got_new_hat.emit(index)
