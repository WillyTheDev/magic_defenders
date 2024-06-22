class_name Turret
extends Defense

var target : Enemy = null

func _abstract_turret_ready():
	pass

func _ready():
	%FireAudio.volume_db = Global.sound_volume
	var DefenseTimer = get_node("/root/Game/DefenseTimer")
	DefenseTimer.timeout.connect(_on_timer_timeout)
	current_health = Global.getTurretHealth()
	add_to_group("has_static_properties")
	print("Turret fire rate : %s " % Global.getDefenseFireRate())
	%TimerShoot.wait_time = Global.getDefenseFireRate()
	%ShootZone.scale.x = Global.getDefenseRange()
	%ShootZone.scale.y = Global.getDefenseRange()
	_abstract_turret_ready()
	
func _apply_modification(args : Callable):
	args.call(self)

func abstract_on_body_exited_defense_zone():
	print("abstract turret on body exited defense zone")

func abstract_build_defense():
		%ShootingZoneSprite.visible = false
		%ShootZone.collision_mask = 1

func shoot():
	if target != null:
		%FireAudio.play()
		const FIRE_BOLT = preload("res://GameElements/Spells/magic_bolt.tscn")
		var new_fire_bolt = FIRE_BOLT.instantiate()
		new_fire_bolt.damage = Global.getDefenseDamage()
		new_fire_bolt.global_position = %ShootingPoint.global_position
		new_fire_bolt.global_rotation = %ShootingPoint.global_rotation
		new_fire_bolt.direction = (global_position - target.global_position).normalized() * -1
		get_parent().add_child(new_fire_bolt)
	else:
		for body in %ShootZone.get_overlapping_bodies():
			print("here is a enemy still on the shoot zone : %s " % body)
			if body is Enemy:
				target = body
				break;


func take_damage(damage):
	if cumulated_damage > 0:
		abstract_defense_take_damage()
		current_health -= damage
		if current_health <= 0:
			abstract_final_action()
			const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
			var new_smoke = SMOKE.instantiate()
			new_smoke.global_position = global_position
			get_parent().add_child(new_smoke)
			queue_free()
		else:
			var values = (255 * (current_health/Global.getTurretHealth()))
			modulate = "ff%x%xff" % [values, values]
		
func abstract_input(event):
	if event.is_action_pressed("show_shoot_zone"):
		%ShootingZoneSprite.visible = true
	elif event.is_action_released("show_shoot_zone"):
		%ShootingZoneSprite.visible = false

func heal_defense(amount):
	current_health = clamp(amount, 0,Global.getTurretHealth())
	var values = (255 * (current_health/Global.getTurretHealth()))
	modulate = "ff%x%xff" % [values, values]

func _on_timer_shoot_timeout():
	shoot()

func _on_shoot_zone_body_exited(_body):
	target = null
	if %ShootZone != null:
		print("An enemy has exited the shoot zone !")
		for body in %ShootZone.get_overlapping_bodies():
			print("here is a enemy still on the shoot zone : %s " % body)
			if body is Enemy:
				target = body
				break;

func _on_shoot_zone_body_entered(body):
	if target == null && body is Enemy:
		target = body
