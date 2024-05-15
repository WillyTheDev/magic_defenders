extends Node2D


func _on_new_game_button_pressed():
	print("New Game cliqued !")
	get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")
