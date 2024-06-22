extends CanvasLayer

var options_menu_open = false
var game_was_paused = false
@export var is_on_welcome_screen = false
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

func _ready():
	AudioServer.set_bus_volume_db(SFX_BUS_ID,linear_to_db(Global.sound_volume))
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID,linear_to_db(Global.audio_volume))
	%AudioSlider.value = Global.audio_volume
	%SoundSlider.value = Global.sound_volume
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
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID,linear_to_db(value))
	Global.audio_volume = value

func _on_sound_slider_value_changed(value):
	Global.sound_volume = value
	AudioServer.set_bus_volume_db(SFX_BUS_ID,linear_to_db(value))

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


