extends PathFollow2D

@export var speed = 0.01

func _process(delta):
	progress_ratio += (delta * speed)
	rotation = 0
