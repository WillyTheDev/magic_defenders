class_name MagicBolt
extends Area2D

const SPEED = 700

var damage = 1
var travelled_distance = 0
var direction

static var range = 1600
static var has_auto_target_on = false
static var is_reducing_speed = false
static var is_passing_through = false
static var texture = preload("res://Assets/Player/fire_bolt.png")
var target : Enemy = null
var nb_of_rebound = 5

func _ready():
	%MagicBoltSprite.texture = texture

func _physics_process(delta):
	if has_auto_target_on && target != null:
		direction = (global_position - target.global_position).normalized() * -1
	rotate(6 * delta)
	position += direction * SPEED * delta
	travelled_distance += delta * SPEED
	if travelled_distance > range :
		queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		print("Body touched !")
		var dmg_indicator = preload("res://GameElements/misc/damage_indicator.tscn").instantiate()
		dmg_indicator.set_value(int(damage * 10))
		body.add_child(dmg_indicator)
		body.take_damage(damage)
		
		nb_of_rebound -= 1
		if nb_of_rebound <= 0:
			queue_free()
		
		if has_auto_target_on:
			var got_new_target = false
			for enemy in %AutoTargetZone.get_overlapping_bodies():
				if enemy is Enemy && enemy != target:
					print("bolt found a new enemy !")
					target = enemy
					got_new_target = true
					break
			if got_new_target == false:
				target = null
				queue_free()
					
		if is_reducing_speed:
			body.speed = clamp(body.speed * 0.8, 30, 300)
			
		if is_passing_through == false && has_auto_target_on == false:
			print("removing magic bolt !")
			queue_free()
		


func _on_auto_target_zone_body_entered(body):
	if body is Enemy:
		target = body
