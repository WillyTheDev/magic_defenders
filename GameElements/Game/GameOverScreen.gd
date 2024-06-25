class_name GameOverScreen
extends CanvasLayer

var wave:int = 0
var game_is_over = false

func _on_quit_to_menu_pressed():
	Global.save_game()
	get_tree().call_group("has_static_properties", "_reinitialize_static_properties")
	get_tree().paused = false
	$/root/Game/TransitionLayer.close_transition()

		
func _on_restart_button_pressed():
	Global.save_game()
	get_tree().reload_current_scene()
	
func game_completed(wave:int, difficulty : int, map_of_game: Node):
	if game_is_over == false:
		visible = true
		game_is_over = true
		%GameOverAnimation.play("show_game_over")
		%GameOverAnimation.queue("show_third_star")
		self.wave = wave
		Global.accumulated_gold += Global.gold_reward
		if Global.is_urgent_quest:
			Global.urgent_quests_completed += 1
		%GameOverTitle.text = "Success !"
		%ScoreLabel.text = "You've completed this map and survided :\n %s" % wave
		$/root/Game/Confetti.play_confetti()
	
func game_over(value):
	if game_is_over == false:
		game_is_over = true
		print("GAME IS OVER : Core has been destroyed !")
		visible = true
		await get_tree().create_timer(1).timeout
		%GameOverAnimation.play("show_game_over")
		%GameOverPlayer.play()
		self.wave = Game.current_wave
		if Global.selected_difficulty == 99 && wave > Global.map_challenge_score["map_%s" % Global.selected_map]:
			Global.map_challenge_score["map_%s" % Global.selected_map] = self.wave
			print(Global.map_challenge_score["map_%s" % Global.selected_map])
		%ScoreLabel.text = "The lotus has been destroyed\n You survived : %s waves" % wave


func _on_transition_layer_transition_is_finished(anim_name):
	print("Game over is visible ? %s" % visible)
	if anim_name == "close_transition" && visible == true:
		Global.selected_map = 0
		Global.selected_difficulty = 0
		get_tree().paused = false
		get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")
