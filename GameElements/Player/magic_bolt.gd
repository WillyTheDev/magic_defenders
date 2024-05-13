class_name MagicBolt
extends Area2D

const SPEED = 500
const RANGE = 1200
var damage = 1
var travelled_distance = 0
var direction
static var has_auto_target_on = false
static var is_reducing_speed = false
static var is_passing_through = false
var target : Node2D = null

func _physics_process(delta):
	if has_auto_target_on && target != null:
		direction = (global_position - target.global_position).normalized() * -1
	rotate(6 * delta)
	position += direction * SPEED * delta
	if travelled_distance > RANGE :
		queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		var dmg_indicator = preload("res://GameElements/misc/damage_indicator.tscn").instantiate()
		dmg_indicator.set_value(int(damage * 10))
		body.add_child(dmg_indicator)
		body.take_damage(damage)
		if is_reducing_speed:
			body.speed = clamp(body.speed * 0.8, 30, 300)
		if is_passing_through == false:
			queue_free()
		


func _on_auto_target_zone_body_entered(body):
	if body is Enemy:
		target = body
