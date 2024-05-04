extends CharacterBody2D

const MANA_AMOUNT = 1

signal reward_player()

var health = 3

@onready var core = get_node("/root/Game/Core")

func play_animation_hit():
	%AnimationPlayer.play("hit")
	%AnimationPlayer.queue("idle")
	
func play_animation_idle():
	%AnimationPlayer.play("idle")


func _ready():
	play_animation_idle()
	
	
func _physics_process(delta):
	var direction = global_position.direction_to(core.global_position)
	velocity = direction * 150.0
	move_and_slide()


func take_damage():
	play_animation_hit()
	health -= 1
	if health <= 0:
		reward_player.emit(MANA_AMOUNT)
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		new_smoke.global_position = global_position
		get_parent().add_child(new_smoke)
		queue_free()
	
