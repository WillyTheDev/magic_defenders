class_name Enemy
extends CharacterBody2D

@export var speed = 0.1
@export var MANA_AMOUNT = 1
@export var health = 3

signal slime_has_been_killed

func play_animation_hit():
	%AnimationPlayer.play("hit")
	%AnimationPlayer.queue("idle")
	
func play_animation_idle():
	%AnimationPlayer.play("idle")


func _ready():
	play_animation_idle()

func _process(delta):
	get_parent().progress_ratio += delta * speed

func take_damage():
	play_animation_hit()
	health -= 1
	if health <= 0:
		slime_has_been_killed.emit()
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		get_parent().add_child(new_smoke)
		const MANA = preload("res://GameElements/misc/mana.tscn")
		var new_mana = MANA.instantiate()
		new_mana.rotation = rotation
		get_parent().add_child(new_mana)
		queue_free()
	
func no_longer_attacking_defense():
	speed = 0.1
