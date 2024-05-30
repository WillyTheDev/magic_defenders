class_name FrostBolt
extends MagicBolt

func abstrat_bolt_effect_on_body(body: Node2D):
	if body.speed > 0:
		body.speed = clamp(body.speed * 0.2, 40, 300)
		body.modulate = "6464ff"
		damage = Global.getPlayerDamage() / 2
		
		
