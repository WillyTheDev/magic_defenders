class_name VisionTurret
extends Turret

var debuf = Sprite2D.new()

func abstract_build_defense():
		%ShootingZoneSprite.visible = false
		%ShootZone.set_collision_mask_value(1, true)
		%ShootZone.set_collision_mask_value(2, true)

func _abstract_turret_ready():
	$AnimationPlayer.play("idle")

func shoot():
	var nb_of_enemy = 0
	for body in %ShootZone.get_overlapping_bodies():
		if body is Enemy:
			%FireAudio.play()
			var debuff = preload("res://GameElements/defense/debuff.tscn").instantiate()
			body.collision_layer = 1
			body.collision_mask = 1
			body.add_child(debuff)
			body.base_damage = clamp(body.base_damage - 1, 0.5, 10)
			break
