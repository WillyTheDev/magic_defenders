extends Node2D

func _ready():
	Global.load_game()
	%TransitionLayer.open_transition()

func _on_new_game_button_pressed():
	Global.new_save()
	Global.load_game()
	get_tree().change_scene_to_file("res://GameElements/Screens/select_map_screen.tscn")


func _on_quit_button_pressed():
	Global.save_game()
	get_tree().quit()


func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://GameElements/Screens/select_map_screen.tscn")
