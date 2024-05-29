class_name AoeTurret
extends Turret


func shoot():
	if %ShootZone.get_overlapping_bodies().size() > 1:
		print("Turret is Shooting !")
		%FireAudio.play()
		const SMOKE = preload("res://smoke_explosion/merlin_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		new_smoke.global_position = global_position
		new_smoke.scale = Vector2(2,2)
		get_parent().add_child(new_smoke)
		var bodies = %ShootZone.get_overlapping_bodies()
		for bodyInZone in bodies:
			if bodyInZone is Enemy:
				bodyInZone.take_damage(clamp(Global.getPlayerDamage()/2, 0.1, 4))
		target = null
