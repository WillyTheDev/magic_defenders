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
	player_manager.apply_change.connect(update_skills)
	_init_selected_skill()
	update_skills()
	update_skill_list()

func _init_selected_skill():
	var index = 0
	for skill_index in Global.selected_skills.values():
		selected_skills[index] = skills[skill_index]
		index += 1
	
func update_skills():
	%SkillButton_1.texture_normal = selected_skills[0].texture_normal
	%SkillButton_1.texture_hover = selected_skills[0].texture_hover
	%SkillButton_1/ProgressBarBackground.max_value = selected_skills[0].mana_cost
	%SkillButton_2.texture_normal = selected_skills[1].texture_normal
	%SkillButton_2.texture_hover = selected_skills[1].texture_hover
	%SkillButton_2/ProgressBarBackground.max_value = selected_skills[1].mana_cost
	%SkillButton_3.texture_normal = selected_skills[2].texture_normal
	%SkillButton_3.texture_hover = selected_skills[2].texture_hover
	%SkillButton_3/ProgressBarBackground.max_value = selected_skills[2].mana_cost
	%SkillButton_4.texture_normal = selected_skills[3].texture_normal
	%SkillButton_4.texture_hover = selected_skills[3].texture_hover
	%SkillButton_4/ProgressBarBackground.max_value = selected_skills[3].mana_cost
	
func update_progress_bar(current_mana: int):
	%SkillButton_1/ProgressBarBackground.value = selected_skills[0].mana_cost - current_mana
	%SkillButton_2/ProgressBarBackground.value = selected_skills[1].mana_cost - current_mana
	%SkillButton_3/ProgressBarBackground.value = selected_skills[2].mana_cost - current_mana
	%SkillButton_4/ProgressBarBackground.value = selected_skills[3].mana_cost - current_mana
	
	
# List of Skill
static var skills : Array[Skill] = [
	Skill.new(10,
	 preload("res://Assets/UI/Skills_button/defense_normal.png"),
	 preload("res://Assets/UI/Skills_button/defense_hover.png"),
	 preload("res://GameElements/defense/defense.tscn"),
	"A defense",
	"defense"),
	Skill.new(20,
	 preload("res://Assets/UI/Skills_button/turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/turret_hover.png"),
	 preload("res://GameElements/defense/turret.tscn"),
	"a balanced turret",
	"defense"),
	Skill.new(60,
	 preload("res://Assets/UI/Skills_button/meteor_normal.png"),
	 preload("res://Assets/UI/Skills_button/meteor_hover.png"),
	 preload("res://GameElements/Spells/meteor_bolt.tscn"),
	"A meteor",
	"spell"),
	Skill.new(40,
	 preload("res://Assets/UI/Skills_button/fire_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/fire_turret_hover.png"),
	 preload("res://GameElements/defense/fire_turret.tscn"),
	"A fire turret",
	"defense"),
	Skill.new(40,
	 preload("res://Assets/UI/Skills_button/frost_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/frost_turret_hover.png"),
	 preload("res://GameElements/defense/frost_turret.tscn"),
	"A frost turret",
	"defense")
]
	
func show_skill_list():
	print(Game.is_idle)
	if Game.is_idle && PlayerManager.is_open:
		%SkillList.visible = true

func hide_skill_list():
	%SkillList.visible = false
	
func update_skill_list():
	for skill in skills:
		%SkillList.add_icon_item(skill.texture_normal, true)

func _on_skill_list_item_clicked(index, at_position, mouse_button_index):
	selected_skills[skill_to_update] = skills[index]
	update_skills()
	hide_skill_list()


func _on_skill_button_1_pressed():
	skill_to_update = 0
	show_skill_list()


func _on_skill_button_2_pressed():
	skill_to_update = 1
	show_skill_list()


func _on_skill_button_3_pressed():
	skill_to_update = 2
	show_skill_list()


func _on_skill_button_4_pressed():
	skill_to_update = 3
	show_skill_list()


func _on_player_manager_apply_change():
	var mana = get_node("/root/Game/Player").mana_amount
	update_progress_bar(mana)
