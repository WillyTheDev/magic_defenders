class_name Bat
extends Enemy

var target = null

func _ready():
	play_animation_idle()
	target = get_parent().get_node("Core")

func _physics_process(delta):
	var direction = (global_position - target.global_position).normalized() * -1
	position += delta * speed * direction

