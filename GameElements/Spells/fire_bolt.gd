class_name FireBolt
extends MagicBolt

func abstrat_bolt_effect_on_body(body: Node2D):
	body.modulate.r = 300
	if body.is_in_group("Burning") == false:
		var timer = Timer.new()
		timer.autostart = true
		body.add_to_group("Burning")
		timer.timeout.connect(body.take_damage.bind((clamp(damage/3,0.1,5))))
		body.add_child(timer)
	
