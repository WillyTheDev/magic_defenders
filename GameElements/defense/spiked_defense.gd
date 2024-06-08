class_name Spiked_Defense
extends Defense

func abstract_defense_take_damage():
	for body in %AttackZone.get_overlapping_bodies():
		if body is Enemy:
			body.take_damage(Global.getDefenseDamage()/4)
