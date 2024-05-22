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
	%SelectMapScreen.show_select_map()


func _on_quit_button_pressed():
	%ClickPlayer.play()
	Global.save_game()
	get_tree().quit()


func _on_continue_button_pressed():
	%ClickPlayer.play()
	%SelectMapScreen.show_select_map()


func _on_options_menu_audio_value_changed():
	%BackgroundAudioPlayer.volume_db = Global.audio_volume


func _on_settings_button_pressed():
	%OptionsMenu.openOptionsMenu("Welcome Screen")
