extends Node2D

const SPEED = 400

var damage = 30
var travelled_distance = 0

func _ready():
	%AnimationPlayer.play("spawn")
	
func _explode():
	for body in %Area2D.get_overlapping_bodies():
		if body is Enemy:
			var dmg_indicator = preload("res://GameElements/misc/damage_indicator.tscn").instantiate()
			dmg_indicator.set_value(int(damage * 10))
			dmg_indicator.global_position = body.global_position
			get_parent().add_child(dmg_indicator)
			body.take_damage(damage)
	var camera = get_node("/root/Game/Player/Camera2D")
	camera.apply_shake()
	const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
	var new_smoke = SMOKE.instantiate()
	new_smoke.scale.x = 1.5
	new_smoke.scale.y = 1.5
	new_smoke.global_position = global_position
	get_parent().add_child(new_smoke)
	queue_free()
	print("Explode")

		


func _on_animation_player_animation_finished(anim_name):
	_explode()
