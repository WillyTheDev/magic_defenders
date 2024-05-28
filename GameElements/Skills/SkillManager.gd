class_name SkillManager
extends Control
# Skills represents Defenses / turrets and spells that the player can use to defend the core.
# Each skill have :
# - Mana cost
# - Skill Button Texture
# - A scene that will be instantiate when the spell is triggered

static var selected_skills : Array[Skill] = [null, null, null, null]

static var skill_to_update = 0

func _ready():
	var player_manager = get_node("/root/Game/PlayerManager")
	player_manager.apply_change.connect(update_skills_button_ui)
	_init_selected_skill()
	update_skill_list()
	update_skills_button_ui()
	

func _init_selected_skill():
	selected_skills[0] = skills[0]
	selected_skills[1] = skills[1]
	for skill in skills:
		print(Global.player_level)
		print("Player has the required level to get the skill ? %s" % (Global.player_level >= skill.level_required))
		var index = %SkillList.add_item(skill.information,skill.texture_normal, Global.player_level >= skill.level_required)
		%SkillList.set_item_disabled(index, Global.player_level < skill.level_required)
	
func update_skills_button_ui():
	var index = 0
	for skill in selected_skills:
		if skill != null:
			get_node("VBoxContainer/HBoxContainer/SkillButton_%s" % (index + 1)).texture_normal = selected_skills[index].texture_normal
			get_node("VBoxContainer/HBoxContainer/SkillButton_%s" % (index + 1)).texture_hover = selected_skills[index].texture_hover
			get_node("VBoxContainer/HBoxContainer/SkillButton_%s/ProgressBarBackground" % (index + 1)).max_value = selected_skills[index].mana_cost
		index += 1
	
func update_progress_bar():
	print("Update Progress bar !")
	var current_mana = $/root/Game/Player.mana_amount
	var index = 0
	for skill in selected_skills:
		if skill != null:
			print("Updating Progress Bar ! %s" % current_mana)
			get_node("VBoxContainer/HBoxContainer/SkillButton_%s/ProgressBarBackground" % (index + 1)).value = selected_skills[index].mana_cost - current_mana
		index += 1

func toggle_skill_list():
	if Game.is_idle && PlayerManager.is_open:
		print("Skill selection is visible : %s" % %SkillSelection.visible )
		if %SkillSelection.visible:
			%SkillAnimationPlayer.play("hide_list")
		else:
			update_skill_list()
			%SkillAnimationPlayer.play("show_skill_list")
			

	
func update_skill_list():
	var index = 0
	for skill in skills:
		%SkillList.set_item_selectable(index, Global.player_level >= skill.level_required)
		%SkillList.set_item_disabled(index, Global.player_level < skill.level_required)
		index += 1

func _on_skill_button_1_pressed():
	skill_to_update = 0
	toggle_skill_list()


func _on_skill_button_2_pressed():
	skill_to_update = 1
	toggle_skill_list()


func _on_skill_button_3_pressed():
	skill_to_update = 2
	toggle_skill_list()


func _on_skill_button_4_pressed():
	skill_to_update = 3
	toggle_skill_list()


func _on_player_manager_apply_change():
	update_progress_bar()


func _on_skill_list_item_selected(index):
	print("Item Selected !")
	selected_skills[skill_to_update] = skills[index]
	update_skills_button_ui()
	toggle_skill_list()

# List of Skill
static var skills : Array[Skill] = [
	Skill.new(10,
	 preload("res://Assets/UI/Skills_button/defense_normal.png"),
	 preload("res://Assets/UI/Skills_button/defense_hover.png"),
	 preload("res://GameElements/defense/defense.tscn"),
	"A defense",
	"defense",
	1),
	Skill.new(20,
	 preload("res://Assets/UI/Skills_button/turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/turret_hover.png"),
	 preload("res://GameElements/defense/turret.tscn"),
	"a balanced turret",
	"defense",
	1),
	Skill.new(30,
	 preload("res://Assets/UI/Skills_button/frost_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/frost_turret_hover.png"),
	 preload("res://GameElements/defense/frost_turret.tscn"),
	"A frost turret",
	"defense",5),
	Skill.new(40,
	 preload("res://Assets/UI/Skills_button/fire_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/fire_turret_hover.png"),
	 preload("res://GameElements/defense/fire_turret.tscn"),
	"A fire turret",
	"defense",10),
	Skill.new(60,
	 preload("res://Assets/UI/Skills_button/meteor_normal.png"),
	 preload("res://Assets/UI/Skills_button/meteor_hover.png"),
	 preload("res://GameElements/Spells/meteor_bolt.tscn"),
	"A meteor",
	"spell", 15),
]
