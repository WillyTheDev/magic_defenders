extends PathFollow2D

const SPEED = 200

func _process(delta):
	if Game.is_idle == false:
		queue_free()
	progress += delta * SPEED
