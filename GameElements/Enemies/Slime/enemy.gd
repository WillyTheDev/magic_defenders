class_name Enemy
extends CharacterBody2D

static var base_health = 1.0
static var base_speed = 5
static var base_damage = 1
@export var speed_increment = 100
@export var MANA_AMOUNT = 2
@export var health_increment = 0
@export var enemy_damage = 1
@export var follow_path = true
var health = 0
var speed = 0


var total_health = base_health + health_increment
var has_hat = false
var has_loot = false
var loot : Loot = null
var can_take_damage = true
var hat_index = 0
const RECOIL = 5
var took_damage = false
var damage_init_position = 0

signal slime_has_been_killed

func play_animation_hit():
	%AnimationPlayer.play("hit")
	%AnimationPlayer.queue("idle")
	
func play_animation_idle():
	%AnimationPlayer.play("idle")

func reset_speed():
	speed = base_speed + speed_increment

func _ready():
	total_health = base_health + health_increment
	speed = base_speed + speed_increment
	health = total_health
	enemy_damage = base_damage + enemy_damage
	slime_has_been_killed.connect($/root/Game/Spawner.on_enemy_has_been_killed)
	tree_exited.connect(_on_enemy_exited_tree)
	%HealthBar.max_value = total_health
	%HealthBar.value = total_health
	LootManager.add_loot_to_enemy(self)
	play_animation_idle()
	
func _on_enemy_exited_tree():
	slime_has_been_killed.emit()
	
func _on_enemy_modification(args: Callable):
	args.call(self)

func _process(delta):
	if follow_path:
		if took_damage:
			get_parent().progress -= delta * (speed * 4)
			if get_parent().progress <= damage_init_position - RECOIL:
				took_damage = false
		else:
			get_parent().progress += delta * speed
		

func take_damage(damage=1):
	if can_take_damage:
		play_animation_hit()
		%HitAudio.play()
		health -= damage
		took_damage = true
		damage_init_position = get_parent().progress
		%HealthBar.value = health
		var dmg_indicator = preload("res://GameElements/misc/damage_indicator.tscn").instantiate()
		dmg_indicator.set_value(int(damage * 10))
		dmg_indicator.scale = scale
		dmg_indicator.global_position = %Hat.global_position
		get_node("/root/Game").add_child(dmg_indicator)
		if health <= 0:
			can_take_damage = false
			const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
			var new_smoke = SMOKE.instantiate()
			new_smoke.global_position = global_position
			$/root/Game.add_child(new_smoke)
			var mana_to_spawn = floor(randi() % MANA_AMOUNT + 1)
			for mana in mana_to_spawn:
				const MANA = preload("res://GameElements/misc/mana.tscn")
				var new_mana = MANA.instantiate()
				new_mana.rotation = rotation
				new_mana.global_position = global_position + Vector2(randi() % 30, randi() % 30)
				$/root/Game.call_deferred("add_child", new_mana)
			if has_hat:
				var hat = preload("res://GameElements/hat/hat.tscn").instantiate()
				hat.hat_index = hat_index
				hat.get_node("Mana").texture = %Hat.texture
				hat.rotation = rotation
				hat.global_position = global_position + Vector2(randi() % 30, randi() % 30)
				$/root/Game.call_deferred("add_child", hat)
			if has_loot:
				var loot_to_spawn = preload("res://GameElements/misc/loot.tscn").instantiate()
				loot_to_spawn.is_loot = true
				loot_to_spawn.loot = loot
				loot_to_spawn.get_node("LootSprite").texture = loot.texture
				loot_to_spawn.global_position = global_position + Vector2(randi() % 30, randi() % 30)
				loot_to_spawn.get_node("LootSprite").modulate = loot.modulate
				$/root/Game.call_deferred("add_child", loot_to_spawn)
			get_parent().queue_free()
	
func no_longer_attacking_defense():
	speed = 100

func add_hat(index: int):
	has_hat = true
	hat_index = index
	%Hat.texture = load("res://Assets/hats/hat_%s.png" % index)

func add_loot(loot_to_add:Loot):
	has_loot = true
	self.loot = loot_to_add


func _on_area_2d_body_entered(body):
	if body.is_in_group("Defense"):
		print("body is defense !")		
		body.get_parent().cumulated_damage += base_damage
		%WaterRay.rotation = %WaterRay.get_angle_to(body.global_position)
		%WaterRay.visible = true
		speed = 0


func _on_area_2d_body_exited(body):
	if body.is_in_group("Defense"):
		%WaterRay.visible = false
		%WaterRay.rotation = 0
		speed = base_speed + speed_increment
		if body != null:
			body.get_parent().cumulated_damage -= base_damage
