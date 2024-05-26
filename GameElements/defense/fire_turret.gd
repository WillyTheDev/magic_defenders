class_name FireTurret
extends Turret

func _abstract_turret_ready():
	print(Global.getDefenseFireRate() * 3)
	%TimerShoot.wait_time = Global.getDefenseFireRate() * 3
	
func shoot():
	if target != null:
		%FireAudio.play()
		get_node("/root/Game/Player/Camera2D").apply_shake(1)
		const FIRE_BOLT = preload("res://GameElements/Spells/fire_bolt.tscn")
		var new_fire_bolt = FIRE_BOLT.instantiate()
		new_fire_bolt.damage = Global.getDefenseDamage() * 3
		print(new_fire_bolt.damage)
		new_fire_bolt.global_position = %ShootingPoint.global_position
		new_fire_bolt.global_rotation = %ShootingPoint.global_rotation
		new_fire_bolt.direction = (global_position - target.global_position).normalized() * -1
		get_parent().add_child(new_fire_bolt)
