class_name FireBolt
extends MagicBolt

func abstrat_bolt_effect_on_body(body: Node2D):
	body.modulate.r = 300
	var timer = Timer.new()
	timer.autostart = true
	timer.timeout.connect(body.take_damage.bind((clamp(damage/3,0.1,5))))
	body.add_child(timer)
	
