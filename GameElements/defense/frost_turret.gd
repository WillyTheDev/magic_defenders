class_name FrostTurret
extends Turret
	
func shoot():
	if target != null:
		%FireAudio.play()
		const FROST_BOLT = preload("res://GameElements/Spells/frost_bolt.tscn")
		var new_bolt = FROST_BOLT.instantiate()
		new_bolt.damage = Global.getDefenseDamage() / 4
		new_bolt.bolt_range = 300
		new_bolt.global_position = %ShootingPoint.global_position
		new_bolt.global_rotation = %ShootingPoint.global_rotation
		new_bolt.direction = (global_position - target.global_position).normalized() * -1
		get_parent().add_child(new_bolt)
		target = null
	else:
		for body in %ShootZone.get_overlapping_bodies():
			print("here is a enemy still on the shoot zone : %s " % body)
			if body is Enemy:
				target = body
				break;
