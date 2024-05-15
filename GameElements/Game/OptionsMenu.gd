extends CanvasLayer

signal close_options_menu

func _input(event):
	if event.is_action_pressed("show_options"):
		get_tree().paused = !get_tree().paused
		print(get_tree().paused)
		visible = !visible
		close_options_menu.emit()
