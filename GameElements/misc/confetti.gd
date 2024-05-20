extends Node2D

func _ready():
	%EndOfWaveAudio.volume_db = Global.audio_volume

func play_confetti():
	print("Play Confetti")
	%ConfettiLeft.emitting = true
	%ConfettiRight.emitting = true
	%EndOfWaveAudio.play()
