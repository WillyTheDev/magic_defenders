class_name GameOverScreen
extends CanvasLayer

var wave:int = 0

func _on_quit_to_menu_pressed():
	Global.save_game()
	get_tree().call_group("has_static_properties", "_reinitialize_static_properties")
	get_tree().paused = false
	$/root/Game/TransitionLayer.close_transition()

		
func _on_restart_button_pressed():
	get_tree().reload_current_scene()
	
func game_completed(wave:int, difficulty : int, map_of_game: Node):
	visible = true
	%GameOverAnimation.play("show_game_over")
	self.wave = wave
	match difficulty:
		1:
				%GameOverAnimation.queue("show_first_star")
				if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 1:
					Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 1
					Global.get_accumulated_stars()
				
		2:
				%GameOverAnimation.queue("show_second_star")
				if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 2:
					Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 2
					Global.get_accumulated_stars()
		3:
				%GameOverAnimation.queue("show_third_star")
				if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 3:
					Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 3
					Global.get_accumulated_stars()
		4:
				if Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] < 4:
					Global.map_progression["map_%s_%s" % [map_of_game.chapter_index, map_of_game.map_index]] = 4
					Global.unlocked_hats[map_of_game.win_hat_index] = true
					Global.get_accumulated_stars()
	%GameOverTitle.text = "Success !"
	%ScoreLabel.text = "You've completed this map and survided :\n %s" % wave
	$/root/Game/Confetti.play_confetti()
	
func game_over(wave:int):
	visible = true
	%GameOverAnimation.play("show_game_over")
	%GameOverPlayer.play()
	self.wave = wave
	%ScoreLabel.text = "The lotus has been destroyed\n %s waves" % wave


func _on_infinity_button_pressed():
	Global.selected_difficulty = 4
	Global.starting_wave = self.wave
	visible = false
