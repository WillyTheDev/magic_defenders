class_name MagicBolt
extends Area2D

const SPEED = 700

var damage = 1.0
var travelled_distance = 0
var direction

var bolt_range = 1600
@export var is_passing_through = false
var has_touch_enemy = false
var target : Enemy = null

func abstrat_bolt_effect_on_body(_body: Node2D):
	pass


func _reinitialize_static_properties():
	print("Reinitializing Properties !")
	bolt_range = 1600

func _ready():
	add_to_group("has_static_properties")

func _physics_process(delta):
	if target != null:
		direction = (global_position - target.global_position).normalized() * -1
	rotate(6 * delta)
	position += direction * SPEED * delta
	travelled_distance += delta * SPEED
	if travelled_distance > bolt_range :
		queue_free()


func _on_body_entered(body):
	if body is Enemy && has_touch_enemy == false:
		has_touch_enemy = true
		abstrat_bolt_effect_on_body(body)
		body.take_damage(damage)
		# Effect of the magic bolt if you have is passing_through or auto_target_on
		if is_passing_through == false:
			queue_free()
		


func _on_auto_target_zone_body_entered(body):
	if body is Enemy:
		target = body

