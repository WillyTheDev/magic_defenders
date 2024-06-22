class_name Baliste
extends Turret
	
func shoot():
	if target != null:
		%FireAudio.play()
		var ARROW = load("res://GameElements/Spells/arrow.tscn")
		var new_bolt = ARROW.instantiate()
		print(new_bolt)
		new_bolt.damage = Global.getDefenseDamage() / 3
		new_bolt.bolt_range = 200 * (1+Global.defense_stat_range)
		new_bolt.global_position = %ShootingPoint.global_position
		var direction = %ShootingPoint.global_position.direction_to(%Target.global_position)
		var angle = rad_to_deg(Vector2.RIGHT.angle_to(direction)) + 90
		print("Shoot at angle .. : %s" % angle)
		new_bolt.rotation_degrees = angle
		new_bolt.direction = direction
		get_parent().add_child(new_bolt)
		target = null
