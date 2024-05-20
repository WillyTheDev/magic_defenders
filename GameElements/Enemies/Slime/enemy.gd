class_name Enemy
extends CharacterBody2D

static var base_health = 5.0
var base_speed = 100
@export var speed = 100
@export var MANA_AMOUNT = 2
@export var health_increment = 0
var health = 0
@export var enemy_damage = 1
@export var follow_path = true

var total_health = base_health + health_increment

signal slime_has_been_killed

func play_animation_hit():
	%AnimationPlayer.play("hit")
	%AnimationPlayer.queue("idle")
	
func play_animation_idle():
	%AnimationPlayer.play("idle")


func _ready():
	total_health = base_health + health_increment
	base_speed = speed
	print("Enemy health increment : %s" % health_increment)
	print("Enemy total health : %s" % total_health)
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
		

func take_damage(damage):
	play_animation_hit()
	%HitAudio.play()
	health -= damage
	%HealthBar.value = health
	if health <= 0:
		slime_has_been_killed.emit()
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
		queue_free()
	
func no_longer_attacking_defense():
	speed = 100
