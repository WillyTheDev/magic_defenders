class_name Core
extends Defense

signal core_destroyed

func _ready():
	add_to_group("has_static_properties")
	var DefenseTimer = get_node("/root/Game/DefenseTimer")
	DefenseTimer.timeout.connect(_on_timer_timeout)
	current_health = 10
	%CoreAttackedPlayer.volume_db = Global.sound_volume

func abstract_final_action():
	$/root/Game/UI/CoreAttackedRect.visible = false
	destroy_core()

func abstract_defense_take_damage():
	if cumulated_damage > 0:
		var vignette = get_node("/root/Game/UI/CoreAttackedRect")
		vignette.visible = true
		%CoreAttackedPlayer.play()
		var timer = Timer.new()
		timer.wait_time = 0.4
		timer.one_shot = true
		timer.autostart = true	
		add_child(timer)
		timer.timeout.connect(func():
			vignette.visible = false
			timer.queue_free()
			)
	

func destroy_core():
	get_node("/root/Game/GameOverScreen").game_over($/root/Game.current_wave)
	
