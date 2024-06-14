class_name Player
extends CharacterBody2D

var starting_mana_amount = 30
@export var player_last_skill_level = 20
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
var applying_skill_index : int = 0
var is_building = false
var nearest_npc_index : int = 0

signal player_has_level_up
signal player_update_mana_amount
signal show_cards
signal player_has_shoot
signal player_got_new_hat

static var magic_bolt = null

func _ready():
	var inventoryManager = get_node("/root/Game/PlayerManager/InventoryManager")
	var optionMenu = get_node("/root/Game/OptionsMenu")
	var uiMenu = get_node("/root/Game/UI")
	player_has_level_up.connect(uiMenu.show_available_point)
	screen_size = get_node("/root/Game/Map/MapLimit").global_position
	_update_sound_volume()
	update_mana_amount(starting_mana_amount, false)
	magic_bolt = preload("res://GameElements/Spells/magic_bolt.tscn")
	inventoryManager.apply_hat()

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

func _physics_process(_delta):
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * player_speed
	move_and_slide()
	if velocity.length() > 0.0:
		if %WalkAudio.playing == false:
			%WalkAudio.playing = true
		%PlayerAnimation.play_animation_walk();
		%DustParticle.emitting = true
		%DustParticle.process_material.gravity = Vector3(direction.x, direction.y, 0) * -1
	else:
		%PlayerAnimation.play_animation_idle();
		%WalkAudio.playing = false
		%DustParticle.emitting = false

func _input(event):
	if event.is_action_pressed("left_click"):
		if is_building:
			_place_defense()
		else:
			if ammo > 0:
				%AutoShootTimer.start()
				_shoot()
			else:
				_reload()
	if event.is_action_released("left_click"):
			%AutoShootTimer.stop()
	if event.is_action_pressed("interact"):
		if get_node_or_null("/root/Game/Map/NPCManager") != null:
			$/root/Game/Map/NPCManager.interact_with_npc(nearest_npc_index)
	#====================
	#Skills Input
	#====================
	if event.is_action_pressed("skill_1"):
		on_skill_pressed(0)
	if event.is_action_pressed("skill_2"):
		on_skill_pressed(1)
	if event.is_action_pressed("skill_3"):
		on_skill_pressed(2)
	if event.is_action_pressed("skill_4"):
		on_skill_pressed(3)
	
	
	if event.is_action_pressed("show_options"):
		if is_building && defense_to_be_placed != null:
			defense_to_be_placed.queue_free()
			update_mana_amount(SkillManager.selected_skills[applying_skill_index].mana_cost, false)
	if event.is_action_released("show_options"):
		is_building = false
	if event.is_action_pressed("reload"):
		_reload()
			


func _reload():
	if %ReloadTimer.is_stopped():
		%ReloadAnimation.play("reload")
		%ReloadTimer.start()

func _shoot():
	%FireAudio.play()
	%Camera2D.apply_shake(0.5)
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
	if defense_to_be_placed != null && defense_to_be_placed.can_be_placed:
		%PlaceDefenseAudio.play()
		is_building = false	
	else:
		is_building = false
		
func on_skill_pressed(index : int):
	if SkillManager.selected_skills[index] != null:
		var price = SkillManager.selected_skills[index].mana_cost
		if mana_amount >= price && is_building == false:
			update_mana_amount(-price, false)
			if(SkillManager.selected_skills[index].type == "defense"):
				is_building = true
				var skill_object = SkillManager.selected_skills[index].scene
				var new_object = skill_object.instantiate()
				new_object.global_position = get_global_mouse_position()
				new_object.rotation = get_angle_to(get_global_mouse_position())
				defense_to_be_placed = new_object
				applying_skill_index = index
				get_parent().add_child(new_object)
			else:
				var skill = SkillManager.selected_skills[index].scene.instantiate()
				skill.global_position = get_global_mouse_position()
				get_parent().add_child(skill)

func _on_reload_timer_timeout():
	ammo = base_ammo
	player_has_shoot.emit(ammo)
	
func _on_auto_shoot_timer_timeout():
	if ammo > 0:
		_shoot()
	elif %ReloadTimer.is_stopped():
		_reload()
		
func get_new_hat(index : int):
	Global.unlocked_hats["hat_%s" % index] = true
	player_got_new_hat.emit(index)
	
func add_new_loot(loot: Loot):
	Global.inventory.loots[loot.type].append(loot)
	Global.inventory.new_loots[loot.type] = true
