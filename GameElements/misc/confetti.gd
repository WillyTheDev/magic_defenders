extends Node2D

func play_confetti(event):
	print("Play Confetti")
	%ConfettiLeft.emitting = true
	%ConfettiRight.emitting = true
	if event == "level up":
		%LevelupAudio.play()
	else:
		%EndOfWaveAudio.play()
