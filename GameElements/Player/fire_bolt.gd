extends Area2D
const SPEED = 500
const RANGE = 1200
var damage = 1
var travelled_distance = 0
var direction

func _physics_process(delta):
	rotate(6 * delta)
	
	position += direction * SPEED * delta
	
	if travelled_distance > RANGE :
		queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		var dmg_indicator = preload("res://GameElements/misc/damage_indicator.tscn").instantiate()
		dmg_indicator.set_value(damage * 10)
		body.add_child(dmg_indicator)
		body.take_damage(damage)
		queue_free()
