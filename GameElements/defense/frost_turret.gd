class_name FrostTurret
extends Turret

func _abstract_turret_ready():
	%TimerShoot.wait_time = Global.getDefenseFireRate() * 1.5
	
func shoot():
	if target != null:
		%FireAudio.play()
		const FROST_BOLT = preload("res://GameElements/Spells/frost_bolt.tscn")
		var new_bolt = FROST_BOLT.instantiate()
		new_bolt.damage = Global.getDefenseDamage() / 2
		print(new_bolt.damage)
		new_bolt.bolt_range = 300
		new_bolt.global_position = %ShootingPoint.global_position
		new_bolt.global_rotation = %ShootingPoint.global_rotation
		new_bolt.direction = (global_position - target.global_position).normalized() * -1
		get_parent().add_child(new_bolt)
		new_bolt = FROST_BOLT.instantiate()
		new_bolt.damage = Global.getDefenseDamage() / 2
		print(new_bolt.damage)
		new_bolt.bolt_range = 300
		new_bolt.global_position = %ShootingPoint.global_position
		new_bolt.global_rotation = %ShootingPoint.global_rotation
		new_bolt.direction = (global_position - target.global_position).normalized()
		get_parent().add_child(new_bolt)
		target = null
