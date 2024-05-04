class_name Enemy
extends CharacterBody2D

@export var speed = 0.1
@export var MANA_AMOUNT = 1
@export var health = 3

signal reward_player()

@onready var core = get_node("/root/Game/Core")

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
		reward_player.emit(MANA_AMOUNT)
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		get_parent().add_child(new_smoke)
		queue_free()
	
func no_longer_attacking_defense():
	speed = 0.1
