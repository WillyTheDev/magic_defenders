extends CanvasLayer

func show_next_wave_label():
	%UIAnimationPlayer.play("showWaveLabel")

func show_available_point():
	%AvailablePoints.visible = true
	%UIAnimationPlayer.play("show_available_point")
	
func hide_available_point():
	%AvailablePoints.visible = false


func _on_player_manager_player_has_available_point(value:bool):
	if value :
		show_available_point()
	else :
		hide_available_point()
