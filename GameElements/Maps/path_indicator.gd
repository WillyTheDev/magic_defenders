extends PathFollow2D

const SPEED = 200

func _process(delta):
	if Game.is_idle == false:
		visible = false
	elif visible == false :
		visible = true
	progress += delta * SPEED
