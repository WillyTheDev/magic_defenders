extends CanvasLayer

@export var nb_chapter = 1
@export var nb_map = 1

@export var stars_to_unlock_map = [0,3,5,7,9,11]


const MAX_NB_MAP_PER_CHAPTER = 6
var actual_chapter = 1

func _input(event):
	if event.is_action_pressed("show_options"):
		get_tree().change_scene_to_file("res://GameElements/Screens/welcome_screen.tscn")
		
		
func _ready():
	for map in range(1, nb_map + 1):
		var btn = get_node("GridContainer/map_%s" % map)
		var label = get_node("GridContainer/map_%s/Label" % map)
		if stars_to_unlock_map[map - 1] > Global.accumulated_stars:
			btn.disabled = true
			label.text = "%s" % (stars_to_unlock_map[map - 1] - Global.accumulated_stars)
			btn.texture_normal = load("res://Assets/UI/map_selection_button/map_0.png")
			btn.texture_hover = load("res://Assets/UI/map_selection_button/map_0_hover.png")
			btn.texture_pressed = load("res://Assets/UI/map_selection_button/map_0_clicked.png")
		else:
			btn.texture_normal = load("res://Assets/UI/map_selection_button/map_%s_%s.png" % [actual_chapter, map])
			btn.texture_hover = load("res://Assets/UI/map_selection_button/map_%s_%s_hover.png" % [actual_chapter, map])
			btn.texture_pressed = load("res://Assets/UI/map_selection_button/map_%s_%s_cliqued.png" % [actual_chapter, map])
		var star_1 = get_node("GridContainer/map_%s/HBoxContainer/star_1" % map)
		var star_2 = get_node("GridContainer/map_%s/HBoxContainer/star_2" % map)
		var star_3 = get_node("GridContainer/map_%s/HBoxContainer/star_3" % map)
		match Global.map_progression["map_%s_%s" % [actual_chapter , map]]:
			3.0:
				print("Loading 3 new texture...")
				star_3.texture = load("res://Assets/UI/map_selection_button/star_unlocked.png")
				star_2.texture = load("res://Assets/UI/map_selection_button/star_unlocked.png")
				star_1.texture = load("res://Assets/UI/map_selection_button/star_unlocked.png")
			2.0:
				print("Loading 2 new texture...")
				star_2.texture = load("res://Assets/UI/map_selection_button/star_unlocked.png")
				star_1.texture = load("res://Assets/UI/map_selection_button/star_unlocked.png")
			1.0:
				print("Loading 1 new texture...")
				star_1.texture = load("res://Assets/UI/map_selection_button/star_unlocked.png")
	for map in range(nb_map + 1, MAX_NB_MAP_PER_CHAPTER + 1):
		var btn = get_node("GridContainer/map_%s" %  map)
		var label = get_node("GridContainer/map_%s/Label" % map)
		if stars_to_unlock_map[map - 1] > Global.accumulated_stars:
			label.text = "%s" % (stars_to_unlock_map[map - 1] - Global.accumulated_stars)
		btn.texture_normal = load("res://Assets/UI/map_selection_button/map_0.png")
		btn.texture_hover = load("res://Assets/UI/map_selection_button/map_0_hover.png")
		btn.texture_pressed = load("res://Assets/UI/map_selection_button/map_0_clicked.png")
		

func _launch_game():
	%TransitionLayer.close_transition()
	

func _on_map_1_pressed():
	if nb_map > 0:
		Global.selected_map = 1
		_launch_game()


func _on_map_2_pressed():
	if nb_map > 1:
		Global.selected_map = 2
		_launch_game()


func _on_map_3_pressed():
	if nb_map > 2:
		Global.selected_map = 3
		_launch_game()


func _on_map_4_pressed():
	if nb_map > 3:
		Global.selected_map = 4
		_launch_game()


func _on_map_5_pressed():
	if nb_map > 4:
		Global.selected_map = 5
		_launch_game()


func _on_map_6_pressed():
	if nb_map > 5:
		Global.selected_map = 6
		_launch_game()


func _on_transition_layer_transition_is_finished(anim_name):
	get_tree().change_scene_to_file("res://GameElements/Game/game.tscn")
