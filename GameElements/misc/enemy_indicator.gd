extends Node2D

var target = null
var speed = 2000
var camera = null

func _ready():
	camera = get_parent().get_node("Camera2D")

func _physics_process(delta):
	if target != null :
		var direction = (global_position - target.global_position).normalized() * -1
		position += delta * direction * speed
		global_position.x = clamp(global_position.x,camera.get_screen_center_position().x - get_viewport_rect().size.x / 4,camera.get_screen_center_position().x + get_viewport_rect().size.x / 4)
		global_position.y = clamp(global_position.y,camera.get_screen_center_position().y - get_viewport_rect().size.y / 4,camera.get_screen_center_position().y + get_viewport_rect().size.y / 4)

func _process(delta):
	if (global_position.x <= camera.get_screen_center_position().x - get_viewport_rect().size.x / 4.05 || global_position.x >= camera.get_screen_center_position().x + get_viewport_rect().size.x / 4.05) || ( global_position.y <= camera.get_screen_center_position().y - get_viewport_rect().size.y / 4.05 || global_position.y >= camera.get_screen_center_position().y + get_viewport_rect().size.y / 4.05): 
		visible = true
	else:
		visible = false
		
	if target == null:
		queue_free()
