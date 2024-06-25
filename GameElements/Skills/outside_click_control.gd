extends Control

@export var player : AnimationPlayer
@export var animation_name : String
@export var is_inner_selection: bool = false

func _on_gui_input(event):
	if event is InputEventMouseButton:
		print(event)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			close_selection()

func _input(event):
	if event.is_action_pressed("reload") && get_parent().visible && is_inner_selection:
		close_selection()

func close_selection():
	player.play(animation_name)
	if is_inner_selection == false:
		get_tree().paused = false
		
