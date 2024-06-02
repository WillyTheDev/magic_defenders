class_name SkillSelection
extends CanvasLayer

signal game_launched

func show_skill_selection():
	%SkillSelectionPlayer.play("show_skill_selection")

func _launch_game():
	%ClickPlayer.play()
	$/root/Game/TransitionLayer.close_transition()
	get_tree().paused = false
	game_launched.emit()
	
func _on_texture_button_pressed():
	_launch_game()
