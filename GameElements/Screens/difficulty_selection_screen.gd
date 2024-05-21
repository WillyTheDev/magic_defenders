extends CanvasLayer

func openDifficultySelectionScreen():
	visible = true
	
func _launch_game():
	%ClickPlayer.play()
	%TransitionLayer.close_transition()

func _on_easy_button_pressed():
	Global.selected_difficulty = 1
	_launch_game()


func _on_medium_button_pressed():
	Global.selected_difficulty = 2
	_launch_game()


func _on_hard_button_pressed():
	Global.selected_difficulty = 3
	_launch_game()

func _on_transition_layer_transition_is_finished(anim_name):
	get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")


func _on_infinity_button_pressed():
	Global.selected_difficulty = 4
	_launch_game()
