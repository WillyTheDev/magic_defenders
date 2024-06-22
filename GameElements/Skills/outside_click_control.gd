extends Control

@export var player : AnimationPlayer
@export var animation_name : String

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().paused = false
			player.play(animation_name)
