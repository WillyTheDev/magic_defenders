extends CanvasLayer

var is_open = false

func openDifficultySelectionScreen():
	match int(Global.map_progression["map_%s_%s" % [Global.selected_chapter, Global.selected_map]]):
		1:
			%EasyStar.texture = preload("res://Assets/UI/map_selection_button/star_unlocked.png")
			%MediumStar.texture = preload("res://Assets/UI/map_selection_button/star_locked.png")
			%HardStar.texture = preload("res://Assets/UI/map_selection_button/star_locked.png")
		2:
			%EasyStar.texture = preload("res://Assets/UI/map_selection_button/star_unlocked.png")
			%MediumStar.texture = preload("res://Assets/UI/map_selection_button/star_unlocked.png")
			%HardStar.texture = preload("res://Assets/UI/map_selection_button/star_locked.png")
		3:
			%EasyStar.texture = preload("res://Assets/UI/map_selection_button/star_unlocked.png")
			%MediumStar.texture = preload("res://Assets/UI/map_selection_button/star_unlocked.png")
			%HardStar.texture = preload("res://Assets/UI/map_selection_button/star_unlocked.png")
		0:
			%EasyStar.texture = preload("res://Assets/UI/map_selection_button/star_locked.png")
			%MediumStar.texture = preload("res://Assets/UI/map_selection_button/star_locked.png")
			%HardStar.texture = preload("res://Assets/UI/map_selection_button/star_locked.png")
	visible = true
	is_open = true
	
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

func _on_transition_layer_transition_is_finished(_anim_name):
	get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")


func _on_infinity_button_pressed():
	Global.selected_difficulty = 4
	_launch_game()


func _on_back_button_pressed():
		visible = false
		is_open = false
