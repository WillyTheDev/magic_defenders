class_name Core
extends Defense

signal core_destroyed

func _ready():
	add_to_group("has_static_properties")
	var DefenseTimer = get_node("/root/Game/DefenseTimer")
	DefenseTimer.timeout.connect(_on_timer_timeout)
	current_health = 10
	get_node("/root/Game/PlayerManager").defense_modified.connect(_apply_modification)

func abstract_final_action():
	destroy_core()

func abstract_defense_take_damage():
	if cumulated_damage > 0:
		print("Timer Initialized !") 
		var vignette = get_node("/root/Game/UI/CoreAttackedRect")
		vignette.visible = true
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
	var game = get_node("/root/Game")
	game.game_over()
	
