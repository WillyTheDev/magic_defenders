class_name Turret
extends Defense

static var fire_rate = 1.5
static var damage = 1
static var turret_price = 20
static var turret_shoot_area = 1
var target : Enemy = null


func _ready():
	%TimerShoot.wait_time = fire_rate
	get_node("/root/Game/CardsManager").turret_modified.connect(_apply_modification)
	%ShootZone.scale.x = turret_shoot_area
	%ShootZone.scale.y = turret_shoot_area
	
func _apply_modification(args : Callable):
	args.call(self)

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
		%FireAudio.play()
		const FIRE_BOLT = preload("res://GameElements/Player/fire_bolt.tscn")
		var new_fire_bolt = FIRE_BOLT.instantiate()
		new_fire_bolt.damage = damage
		new_fire_bolt.global_position = %ShootingPoint.global_position
		new_fire_bolt.global_rotation = %ShootingPoint.global_rotation
		new_fire_bolt.direction = (global_position - target.global_position).normalized() * -1
		get_parent().add_child(new_fire_bolt)

func abstract_input(event):
	if event.is_action_pressed("show_shoot_zone"):
		%ShootingZoneSprite.visible = true
	elif event.is_action_released("show_shoot_zone"):
		%ShootingZoneSprite.visible = false


func _on_timer_shoot_timeout():
	shoot()

func _on_shoot_zone_body_exited(body):
	target = null
