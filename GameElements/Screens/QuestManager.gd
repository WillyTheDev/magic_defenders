class_name QuestManager
extends CanvasLayer

var actual_chapter = 1
var gold_texture = preload("res://Assets/loots/bourse.png")
var nb_map_implemented = 5
static var selected_quest = 0
static var proposed_quest = []
static var urgent_quests = [
]

func clear_proposed_quest():
	proposed_quest.clear()

func _input(event):
	if event.is_action_pressed("show_options") && %SelectDifficultyScreen.is_open == false:
		visible = false
		
func show_quests():
	get_tree().paused = true
	if proposed_quest.size() < 1:
		for index in range(4):
			var quest = _generate_quests()
			quest.pressed.connect(clear_proposed_quest)
			%QuestContainer.add_child(quest)
			proposed_quest.append(quest)
			
	%AnimationPlayer.play("show_quests_lists")

func _on_back_button_pressed():
	get_tree().paused = false
	%AnimationPlayer.play("hide_quests_lists")
	
func _generate_quests():
	var quest = preload("res://GameElements/Screens/map_button.tscn").instantiate()
	var difficulty = randi_range(1, 1 + Global.urgent_quests_completed)
	var max_waves = randi_range(5,10)
	var map_select = randi_range(1, nb_map_implemented)
	var sequences : Array[String] = []
	for wave in range(max_waves):
		var sequence = add_normal_slime(difficulty, wave)
		if wave < 3 && wave > 1:
			sequence += add_normal_slime(difficulty, wave)
		if wave >= 3 && wave < 6:
			sequence += add_medium_slime(difficulty, wave)
			sequence += add_bat(difficulty, wave)
			sequence += add_medium_slime(difficulty, wave)
		if wave >= 6:
			sequence += add_medium_slime(difficulty, wave)
			sequence += add_bat(difficulty, wave)
			sequence += add_medium_slime(difficulty, wave)
			sequence += add_hard_slime(difficulty, wave)
		if wave == max_waves:
			sequence += add_mana_slime(difficulty)
		sequence = sequence.erase(0)
		print("Sequence = %s " % sequence)
		sequences.append(sequence)
	var normal_map_texture = load("res://Assets/UI/map_selection_button/map_%s_%s.png" % [actual_chapter, map_select])
	var hover_map_texture = load("res://Assets/UI/map_selection_button/map_%s_%s_hover.png" % [actual_chapter, map_select] )
	var pressed_map_texture = load("res://Assets/UI/map_selection_button/map_%s_%s_clicked.png" % [actual_chapter, map_select] )
	quest.difficulty = difficulty
	quest.waves_to_completed = max_waves
	quest.texture_reward = gold_texture
	quest.map_texture_normal = normal_map_texture
	quest.map_texture_hover = hover_map_texture
	quest.map_texture_clicked = pressed_map_texture
	quest.map_of_quest_index = map_select
	quest.is_day = false
	quest.reward = Quest.reward_type.GOLD
	quest.is_urgent = false
	quest.enemy_sequence = sequences
	quest.required_quests_completed = 0
	quest.has_been_completed  = false
	quest.gold_amount = difficulty * 10
	return quest
	
func add_normal_slime(difficulty, wave):
		return ",%sx%s" % [randi_range(3,7 * difficulty) + wave, 1]

func add_medium_slime(difficulty, wave):
	if difficulty < 2:
		return add_normal_slime(difficulty, wave)
	else:
		return ",%sx%s" % [randi_range(0,1 * difficulty + wave), 2]
	
func add_hard_slime(difficulty, wave):
	if difficulty < 2:
		return add_normal_slime(difficulty, wave)
	elif difficulty < 4:
		return add_medium_slime(difficulty, wave)
	else:
		return ",%sx%s" % [randi_range(0, 1 * (difficulty)), 3]
	
func add_bat(difficulty, wave):
	return ",%sx%s" % [randi_range(1,2 * difficulty), 4]
	
func add_mana_slime(difficulty):
	return ",%sx%s" % [1, 5]
