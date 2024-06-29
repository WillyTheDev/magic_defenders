class_name SkillSelection
extends CanvasLayer

signal game_launched

func show_skill_selection():
	%SkillSelectionPlayer.play("show_skill_selection")
	if Global.player_using_controller:
		await %SkillSelectionPlayer.animation_finished
		%StartButton.grab_focus()

func _launch_game():
	%ClickPlayer.play()
	$/root/Game/TransitionLayer.close_transition()
	get_tree().paused = false
	
func _on_texture_button_pressed():
	QuestManager.is_open = false
	_launch_game()
