extends Node2D

func _ready():
	Global.load_game()
	%BackgroundAudioPlayer.volume_db = Global.audio_volume
	if Global.has_save :
		%ContinueButton.visible = true
	else :
		%NewGameButton.visible = true
	%TransitionLayer.open_transition()

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
	


func _on_options_menu_audio_value_changed():
	%BackgroundAudioPlayer.volume_db = Global.audio_volume


func _on_settings_button_pressed():
	%OptionsMenu.openOptionsMenu("Welcome Screen")


func _on_transition_layer_transition_is_finished(anim_name):
	if anim_name == "close_transition":
		get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")
