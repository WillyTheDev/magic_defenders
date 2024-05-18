class_name MagicBolt
extends Area2D

const SPEED = 700

var damage = 1.0
var travelled_distance = 0
var direction

static var range = 1600
static var has_auto_target_on = false
static var is_reducing_speed = false
static var is_passing_through = false
static var texture = preload("res://Assets/Player/fire_bolt.png")
var target : Enemy = null
var nb_of_rebound = 4

func _reinitialize_static_properties():
	print("Reinitializing Properties !")
	range = 1600
	has_auto_target_on = false
	is_reducing_speed = false
	is_passing_through = false
	texture = preload("res://Assets/Player/fire_bolt.png")

func _ready():
	add_to_group("has_static_properties")
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
	if body is Enemy:
		var dmg_indicator = preload("res://GameElements/misc/damage_indicator.tscn").instantiate()
		dmg_indicator.set_value(int(damage * 10))
		dmg_indicator.scale = body.scale
		dmg_indicator.global_position = global_position
		get_parent().add_child(dmg_indicator)
		body.take_damage(damage)
		nb_of_rebound -= 1
		if nb_of_rebound <= 0:
			queue_free()
		# Effect of the magic bolt if you have auto-target-on
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
				
		# Effect of the magic bolt if you have reducing_speed_on
		if is_reducing_speed:
			if body.speed > 0:
				body.speed = clamp(body.speed * 0.5, 20, 300)
			else :
				body.base_speed = clamp(body.base_speed * 0.5, 20, 300)
			body.modulate = "6464ff"
		# Effect of the magic bolt if you have is passing_through or auto_target_on
		if is_passing_through == false && has_auto_target_on == false:
			print("removing magic bolt !")
			queue_free()
		


func _on_auto_target_zone_body_entered(body):
	if body is Enemy:
		target = body

