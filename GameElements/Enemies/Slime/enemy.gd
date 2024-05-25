class_name Enemy
extends CharacterBody2D

static var base_health = 5.0
static var base_speed = 5
@export var speed_increment = 100
@export var MANA_AMOUNT = 2
@export var health_increment = 0
var health = 0
var speed = 0
@export var enemy_damage = 1
@export var follow_path = true

var total_health = base_health + health_increment
var has_hat = false
var can_take_damage = true
var hat_index = 0

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
	%HealthBar.max_value = total_health
	%HealthBar.value = total_health
	play_animation_idle()
	get_node("/root/Game/PlayerManager").enemy_modified.connect(_on_enemy_modification)
	
func _on_enemy_modification(args: Callable):
	args.call(self)

func _process(delta):
	if follow_path:
		get_parent().progress += delta * speed
		

func take_damage(damage=1):
	if can_take_damage:
		play_animation_hit()
		%HitAudio.play()
		health -= damage
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
			get_parent().add_child(new_smoke)
			var mana_to_spawn = floor(randi() % MANA_AMOUNT + 1)
			for mana in mana_to_spawn:
				const MANA = preload("res://GameElements/misc/mana.tscn")
				var new_mana = MANA.instantiate()
				new_mana.rotation = rotation
				new_mana.global_position += Vector2(randi() % 30, randi() % 30)
				get_parent().call_deferred("add_child", new_mana)
			if has_hat:
				var hat = preload("res://GameElements/hat/hat.tscn").instantiate()
				print(hat_index)
				hat.hat_index = hat_index
				hat.get_node("Mana").texture = %Hat.texture
				hat.rotation = rotation
				hat.global_position += Vector2(randi() % 30, randi() % 30)
				get_parent().call_deferred("add_child", hat)
			slime_has_been_killed.emit()
			queue_free()
	
func no_longer_attacking_defense():
	speed = 100

func add_hat(index: int):
	has_hat = true
	hat_index = index
	%Hat.texture = load("res://Assets/hats/hat_%s.png" % index)
