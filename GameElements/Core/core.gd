class_name Core
extends Defense

signal core_destroyed(position: Vector2)

func _ready():
	has_been_build = true
	add_to_group("has_static_properties")
	print("Core Ready !")
	print(get_node("/root/Game/GameOverScreen"))
	core_destroyed.connect(get_node("/root/Game/GameOverScreen").game_over)
	var DefenseTimer = get_node("/root/Game/DefenseTimer")
	DefenseTimer.timeout.connect(_on_timer_timeout)
	current_health = 20
	%CoreAttackedPlayer.volume_db = Global.sound_volume
	%AnimationPlayer.play("idle")

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
	print("Core Destroyed ! emitting signals")
	core_destroyed.emit(global_position)
	
