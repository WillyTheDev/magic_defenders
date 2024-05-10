class_name Turret
extends Defense

var fire_rate = TurretDefenseManager.turret_fire_rate
var damage = TurretDefenseManager.turret_damage
var target : Enemy = null

func _ready():
	%TimerShoot.wait_time = fire_rate
	get_node("/root/Game/TurretDefenseManager").turret_modified.connect(_apply_modification)
	
func _apply_modification():
	%TimerShoot.wait_time = TurretDefenseManager.turret_fire_rate
	damage = TurretDefenseManager.turret_damage

func abstract_on_body_exited_defense_zone():
	print("abstract turret on body exited defense zone")

func abstract_build_defense():
		%ShootingZoneSprite.visible = false
		%ShootZone.collision_mask = 1

func abstract_on_process():
	if target == null:
		for body in %ShootZone.get_overlapping_bodies():
			if body is Enemy:
				target = body
				break

func shoot():
	if target != null:
		const FIRE_BOLT = preload("res://GameElements/Player/fire_bolt.tscn")
		var new_fire_bolt = FIRE_BOLT.instantiate()
		new_fire_bolt.damage = damage
		new_fire_bolt.global_position = %ShootingPoint.global_position
		new_fire_bolt.global_rotation = %ShootingPoint.global_rotation
		new_fire_bolt.direction = (global_position - target.global_position).normalized() * -1
		get_parent().add_child(new_fire_bolt)


func _on_timer_shoot_timeout():
	shoot()


func _on_shoot_zone_body_exited(body):
	target = null
