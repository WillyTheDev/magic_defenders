extends CanvasLayer

var options_menu_open = false
var game_was_paused = false

signal sound_value_changed()

func _ready():
	%AudioSlider.value = Global.audio_volume

func _input(event):
	if event.is_action_pressed("show_options"):
		if options_menu_open:
			closeOptionsMenu()
		else:
			openOptionsMenu()
			
func openOptionsMenu():
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
	Global.save_game()
	Enemy.base_health = 5
	get_tree().call_group("has_static_properties", "_reinitialize_static_properties")
	get_tree().paused = false
	get_node("/root/Game/TransitionLayer").close_transition()
	


func _on_restart_button_pressed():
	get_tree().call_group("has_static_properties", "_reinitialize_static_properties")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")


func _on_h_slider_value_changed(value):
	Global.audio_volume = value
	var music = get_node("/root/Game/BackgroundAudioPlayer")
	music.volume_db = Global.audio_volume

func _on_sound_slider_value_changed(value):
	Global.sound_volume = value
	sound_value_changed.emit()

func _on_erase_save_button_pressed():
	Global.new_save()
	get_tree().paused = false
	get_node("/root/Game/TransitionLayer").close_transition()



