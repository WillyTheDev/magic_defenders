class_name Enemy
extends CharacterBody2D

@export var speed = 100
@export var MANA_AMOUNT = 2
@export var health = 2
@export var enemy_damage = 1
@export var follow_path = true

signal slime_has_been_killed

func play_animation_hit():
	%AnimationPlayer.play("hit")
	%AnimationPlayer.queue("idle")
	
func play_animation_idle():
	%AnimationPlayer.play("idle")


func _ready():
	play_animation_idle()

func _process(delta):
	if follow_path:
		get_parent().progress += delta * speed

func take_damage(damage):
	play_animation_hit()
	health -= damage
	if health <= 0:
		slime_has_been_killed.emit()
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		get_parent().add_child(new_smoke)
		var mana_to_spawn = floor(randf() * MANA_AMOUNT + 1)
		for mana in mana_to_spawn:
			const MANA = preload("res://GameElements/misc/mana.tscn")
			var new_mana = MANA.instantiate()
			new_mana.rotation = rotation
			get_parent().call_deferred("add_child", new_mana)
		queue_free()
	
func no_longer_attacking_defense():
	speed = 100
