class_name FireBolt
extends MagicBolt

func abstrat_bolt_effect_on_body(body: Node2D):
	body.modulate.r = 400
	var timer = Timer.new()
	timer.autostart = true
	timer.timeout.connect(body.take_damage.bind((damage / 2)))
	body.add_child(timer)
	
