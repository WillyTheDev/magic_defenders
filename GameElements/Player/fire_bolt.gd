extends Area2D
const SPEED = 500
const RANGE = 1200
var travelled_distance = 0
var direction

func _physics_process(delta):
	rotate(6 * delta)
	
	position += direction * SPEED * delta
	
	if travelled_distance > RANGE :
		queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()
