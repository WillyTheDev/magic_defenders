class_name AoeTurret
extends Turret


func shoot():
	var nb_of_enemy = 0
	for body in %ShootZone.get_overlapping_bodies():
		if body is Enemy:
			nb_of_enemy += 1
	if nb_of_enemy > 0:
		%FireAudio.play()
		const SMOKE = preload("res://smoke_explosion/merlin_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		new_smoke.global_position = global_position
		new_smoke.scale = Vector2(Global.getDefenseRange(),Global.getDefenseRange())
		get_parent().add_child(new_smoke)
		var bodies = %ShootZone.get_overlapping_bodies()
		for bodyInZone in bodies:
			if bodyInZone is Enemy:
				bodyInZone.take_damage(clampf(Global.getDefenseDamage()/4, 0.1, 4))
		target = null
