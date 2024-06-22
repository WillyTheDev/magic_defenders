extends CanvasLayer

func _ready():
	%EndOfWaveAudio.volume_db = Global.audio_volume

func play_confetti():
	%ConfettiLeft.emitting = true
	%ConfettiRight.emitting = true
	%EndOfWaveAudio.play()


func _on_control_resized():
	var rect_size = %Control.get_size()
	%ConfettiLeft.position.x = 0
	%ConfettiRight.position.x = rect_size.x
