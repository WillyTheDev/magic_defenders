extends CanvasLayer

var options_menu_open = false
var game_was_paused = false
@export var is_on_welcome_screen = false

signal sound_value_changed()
signal audio_value_changed()

func _ready():
	%AudioSlider.value = Global.audio_volume
	if is_on_welcome_screen == true:
		%RestartButton.visible = false
		%QuitToMenu.visible = false

func _input(event):
	if is_on_welcome_screen == false:
		var player = get_node("/root/Game/Player")
		if event.is_action_pressed("show_options") && player.is_building == false:
				if options_menu_open:
					closeOptionsMenu()
				else:
					openOptionsMenu("")
			
func openOptionsMenu(_from: String):
	options_menu_open = true
	if get_tree().paused:
		game_was_paused = true
	get_tree().paused = true
	visible = true

func closeOptionsMenu():
	options_menu_open = false
	if game_was_paused == false:
		get_tree().paused = false
	visible = false



func _on_quit_to_menu_pressed():
	%ClickPlayer.play()
	Global.save_game()
	get_tree().call_group("has_static_properties", "_reinitialize_static_properties")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameElements/Screens/welcome_screen.tscn")
	

func _on_restart_button_pressed():
	%ClickPlayer.play()
	get_tree().call_group("has_static_properties", "_reinitialize_static_properties")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")


func _on_h_slider_value_changed(value):
	Global.audio_volume = value
	audio_value_changed.emit()

func _on_sound_slider_value_changed(value):
	Global.sound_volume = value
	sound_value_changed.emit()

func _on_erase_save_button_pressed():
	print("ERASING DATA")
	%ClickPlayer.play()
	Global.new_save()
	get_tree().paused = false
	if is_on_welcome_screen:
		closeOptionsMenu()
	else:
		get_tree().change_scene_to_file("res://GameElements/Screens/welcome_screen.tscn")


func _on_resume_button_pressed():
	%ClickPlayer.play()
	closeOptionsMenu()


func _on_hub_button_pressed():
	Global.selected_map = 0
	Global.selected_difficulty = 0
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")

