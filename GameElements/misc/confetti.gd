extends Node2D

func play_confetti():
	%ConfettiLeft.emitting = true
	%ConfettiRight.emitting = true
	%AudioStreamPlayer.play()
