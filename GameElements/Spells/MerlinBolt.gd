class_name MerlinBolt
extends MagicBolt


func abstrat_bolt_effect_on_body(body: Node2D):
	var bodies = %DamageZone.get_overlapping_bodies()
	const SMOKE = preload("res://smoke_explosion/merlin_explosion.tscn")
	var new_smoke = SMOKE.instantiate()
	new_smoke.global_position = global_position
	new_smoke.scale = Vector2(1.2,1.2)
	get_parent().add_child(new_smoke)
	for bodyInZone in bodies:
		if bodyInZone is Enemy:
			bodyInZone.take_damage(clamp(Global.getPlayerDamage()/3, 0.1, 2))
