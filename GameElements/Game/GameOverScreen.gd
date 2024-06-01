class_name GameOverScreen
extends CanvasLayer

var wave:int = 0

func _on_quit_to_menu_pressed():
	Global.save_game()
	get_tree().call_group("has_static_properties", "_reinitialize_static_properties")
	get_tree().paused = false
	$/root/Game/TransitionLayer.close_transition()

		
func _on_restart_button_pressed():
	Global.save_game()
	get_tree().reload_current_scene()
	
func game_completed(wave:int, difficulty : int, map_of_game: Node):
	visible = true
	%GameOverAnimation.play("show_game_over")
	self.wave = wave
	Global.accumulated_gold += Global.gold_reward
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
	Global.save_game()
	Global.selected_difficulty = 4
	Global.starting_wave = self.wave
	visible = false


func _on_transition_layer_transition_is_finished(anim_name):
	print("Game over is visible ? %s" % visible)
	if anim_name == "close_transition" && visible == true:
		Global.selected_map = 0
		Global.selected_difficulty = 0
		get_tree().paused = false
		get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")
