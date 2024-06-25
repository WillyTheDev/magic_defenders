extends Node2D

var mouse_speed = 10.0


func _physics_process(delta):
	var mouse_rel = Vector2.ZERO
	var direction = Input.get_vector("mouse_left", "mouse_right", "mouse_up", "mouse_down")
	if direction != Vector2.ZERO:
		if Global.player_using_controller == false:
			Global.player_using_controller = true
		Input.warp_mouse(Vector2(get_viewport().size/2) + (direction * 250))
		look_at((direction * mouse_speed) + global_position)
	if Global.player_using_controller == false:
		look_at(get_global_mouse_position())


