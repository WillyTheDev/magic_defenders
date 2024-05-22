extends CanvasLayer

signal transition_is_finished(anim_name)

func open_transition():
	%TransitionPlayer.play("open_transition")


func close_transition():
	%TransitionPlayer.play("close_transition")


func _on_transition_player_animation_finished(anim_name):
	transition_is_finished.emit(anim_name)
