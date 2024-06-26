extends Node2D

func _ready():
	Global.load_game()
	%TransitionLayer.open_transition()
	%ContinueButton.grab_focus()
	
func _input(event):
	if event is InputEventMouseButton:
		print("Player moving mouse !")
		Global.player_using_controller = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventJoypadButton:
		print("Player using controller !")
		Global.player_using_controller = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_new_game_button_pressed():
	%ClickPlayer.play()
	Global.new_save()
	Global.load_game()
	Global.selected_map = 0
	Global.selected_difficulty = 0
	get_tree().paused = false
	%TransitionLayer.close_transition()


func _on_quit_button_pressed():
	%ClickPlayer.play()
	Global.save_game()
	get_tree().quit()


func _on_continue_button_pressed():
	%ClickPlayer.play()
	Global.selected_map = 0
	Global.selected_difficulty = 0
	get_tree().paused = false
	%TransitionLayer.close_transition()



func _on_settings_button_pressed():
	%ClickPlayer.play()
	%OptionsMenu.openOptionsMenu("Welcome Screen")


func _on_transition_layer_transition_is_finished(anim_name):
	if anim_name == "close_transition":
		get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")
