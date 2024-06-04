class_name QuestManager
extends CanvasLayer

var actual_chapter = 1
var gold_texture = preload("res://Assets/loots/bourse.png")
var nb_map_implemented = 5
static var selected_quest = 0
static var proposed_quest = []
static var isOpen = false


func clear_proposed_quest():
	print("Quests has been cleared !")
	proposed_quest.clear()

func _input(event):
	if event.is_action_pressed("show_options"):
		visible = false
		
func show_quests():
	isOpen = true
	get_tree().paused = true
	print("Proposed quests : %s" % proposed_quest.size())
	if proposed_quest.size() < 1:
		var urgent_quest = _create_urgent_quests(urgent_quests[Global.urgent_quests_completed])
		urgent_quest.quest_button_pressed.connect(show_skill_selection)
		%QuestContainer.add_child(urgent_quest)
		proposed_quest.append(urgent_quest)
		if Global.urgent_quests_completed > 0:
			for index in range(2,5):
				var quest = _generate_quests()
				quest.quest_button_pressed.connect(show_skill_selection)
				%QuestContainer.add_child(quest)
				proposed_quest.append(quest)
			
	%AnimationPlayer.play("show_quests_lists")

func show_skill_selection():
	%SkillSelection.show_skill_selection()

func _on_back_button_pressed():
	isOpen = false
	get_tree().paused = false
	%AnimationPlayer.play("hide_quests_lists")

func _create_urgent_quests(questData: UrgentQuest):
	var quest = preload("res://GameElements/Screens/map_button.tscn").instantiate()
	var normal_map_texture = load("res://Assets/UI/map_selection_button/urgent_quest.png")
	var hover_map_texture = load("res://Assets/UI/map_selection_button/urgent_quest_hover.png")
	var pressed_map_texture = load("res://Assets/UI/map_selection_button/urgent_quest_clicked.png")
	quest.difficulty = questData.difficulty
	quest.waves_to_completed = questData.waves_to_completed
	quest.texture_reward = questData.reward_texture
	quest.map_texture_normal = normal_map_texture
	quest.map_texture_hover = hover_map_texture
	quest.map_texture_clicked = pressed_map_texture
	quest.map_of_quest_index = questData.map_of_quest_index
	quest.is_day = questData.is_day
	quest.reward = Quest_Button.reward_type.GOLD
	quest.gold_amount = (Global.urgent_quests_completed + 1) * 10
	quest.is_urgent = questData.is_urgent
	quest.enemy_sequence = questData.enemy_sequence
	quest.required_quests_completed = 0
	quest.has_been_completed  = questData.has_been_completed
	return quest

func _generate_quests():
	var quest = preload("res://GameElements/Screens/map_button.tscn").instantiate()
	var difficulty = randi_range(1, Global.urgent_quests_completed)
	var max_waves = randi_range(6,10)
	var map_select = randi_range(1, nb_map_implemented)
	var sequences : Array[String] = []
	for wave in range(max_waves):
		var sequence = add_normal_slime(difficulty, wave)
		if  wave > 0:
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
		if wave == max_waves - 1:
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
	quest.reward = Quest_Button.reward_type.GOLD
	quest.is_urgent = false
	quest.enemy_sequence = sequences
	quest.required_quests_completed = 0
	quest.has_been_completed  = false
	quest.gold_amount = (difficulty * 10) + max_waves
	return quest
	
func add_normal_slime(difficulty, wave):
		return ",%sx%s" % [randi_range(6,10 * difficulty) + wave, 1]

func add_medium_slime(difficulty, wave):
	if difficulty < 2:
		return add_normal_slime(difficulty, wave)
	else:
		return ",%sx%s" % [randi_range(1,1 * difficulty + wave), 2]
	
func add_hard_slime(difficulty, wave):
	if difficulty < 2:
		return add_normal_slime(difficulty, wave)
	elif difficulty < 4:
		return add_medium_slime(difficulty, wave)
	else:
		return ",%sx%s" % [randi_range(1, 1 * (difficulty)), 3]
	
func add_bat(difficulty, _wave):
	return ",%sx%s" % [randi_range(1,2 * difficulty), 4]
	
func add_mana_slime(_difficulty):
	return ",%sx%s" % [1, 5]

static var urgent_quests = [
	UrgentQuest.new("quest_1", 1, 9, 1, true,
		["7x1","10x1","15x1","1x4","15x1,1x4","15x1,1x4,3x1","17x1,1x4,7x1", "20x1,1x4,5x1", "7x4", "30x1,1x5"],
		0,
		preload("res://Assets/UI/map_selection_button/reduced_merchant.png")),
	UrgentQuest.new("quest_2", 2, 9, 2, true,
		["10x1","15x1","15x1,1x2","15x1,1x2,1x4","15x1,1x2,1x4,5x1","15x1,1x2,3x4,5x1","18x1,2x2,5x4,5x1", "18x1,2x2,5x4,5x1", "30x4", "22x1,5x4,2x2,5x1,1x5"],
		0,
		preload("res://Assets/loots/bourse.png")),
	UrgentQuest.new("quest_3", 3, 9, 3, true,
		["10x1","15x1","15x1,1x2","15x1,1x2,1x4","15x1,1x2,1x4,5x1","15x1,2x2,3x4,5x1","18x1,3x2,5x4,5x1", "18x1,3x2,5x4,5x1", "30x4", "22x1,3x2,5x4,3x2,5x1,1x5"],
		0,
		preload("res://Assets/loots/bourse.png")),
	UrgentQuest.new("quest_4", 4, 9, 4, true,
		["10x1","15x1","15x1,1x2","15x1,1x2,1x4","15x1,1x2,1x4,5x1","15x1,2x2,3x4,5x1","18x1,3x2,5x4,5x1", "18x1,3x2,5x4,5x1", "30x4", "22x1,3x2,5x4,3x2,5x1,1x5"],
		0,
		preload("res://Assets/loots/bourse.png")),
	UrgentQuest.new("quest_4", 5, 9, 5, true,
		["10x1","15x1","15x1,1x2","15x1,1x2,1x4","15x1,1x2,1x4,5x1","15x1,2x2,3x4,5x1","18x1,3x2,5x4,5x1", "18x1,3x2,5x4,5x1", "30x4", "22x1,3x2,5x4,3x2,5x1,1x5"],
		0,
		preload("res://Assets/loots/bourse.png")),
]


func _on_skill_selection_game_launched():
	clear_proposed_quest()
	QuestManager.isOpen = false
