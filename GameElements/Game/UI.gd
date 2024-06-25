extends CanvasLayer

func _ready():
	if Global.player_using_controller:
		%WaveActionLabel.text = "[center]Press [img=32x32]res://Assets/UI/input/x.png[/img] to start the next wave ![/center]"

func show_next_wave_label():
	%UIAnimationPlayer.queue("showWaveLabel")
	
func show_available_skill():
	%AvailableSkill.visible = true
	%UIAnimationPlayer.queue("show_available_skill")

func hide_available_skill():
	%AvailableSkill.visible = false

func show_available_point():
	%AvailablePoints.visible = true
	%UIAnimationPlayer.queue("show_available_point")
	
func hide_available_point():
	%AvailablePoints.visible = false

func update_ammo_bar(ammo):
	%AmmoProgressBar.value = ammo
	
func set_ammo_progress_max_value(value):
	%AmmoProgressBar.value = value


func _on_player_manager_player_has_available_point(value:bool):
	if value :
		show_available_point()
	else :
		hide_available_point()



