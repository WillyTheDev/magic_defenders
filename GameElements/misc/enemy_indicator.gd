extends Node2D

var target = null
var speed = 10000

func _physics_process(delta):
	var direction = (global_position - target.global_position).normalized() * -1
	position += delta * direction * speed
	position.x = clamp(position.x, 0 - get_viewport_rect().size.x, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0 - get_viewport_rect().size.y, get_viewport_rect().size.y)

func _process(delta):
	if (position.x == get_viewport_rect().size.x || position.x == 0 - get_viewport_rect().size.x) || ( position.y == 0 - get_viewport_rect().size.y || position.y == get_viewport_rect().size.y): 
		visible = true
	else:
		visible = false
		
	if target == null:
		queue_free()
