class_name Core
extends Defense

signal core_destroyed

func abstract_final_action():
	destroy_core()

func abstract_defense_take_damage():
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
	
