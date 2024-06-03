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
		if Global.unlocked_skills[skill.identifier]:
			skill.unlocked = true
		var index = %SkillList.add_item(skill.information,skill.texture_normal, skill.unlocked)
		%SkillList.set_item_disabled(index, !skill.unlocked)
	
func update_skills_button_ui():
	var index = 0
	for skill in selected_skills:
		print("Update Skill on action bar ! %s" % skill)
		if skill != null:
			get_node("MarginContainer/VBoxContainer/HBoxContainer/SkillButton_%s" % (index + 1)).texture_normal = selected_skills[index].texture_normal
			get_node("MarginContainer/VBoxContainer/HBoxContainer/SkillButton_%s" % (index + 1)).texture_hover = selected_skills[index].texture_hover
			get_node("MarginContainer/VBoxContainer/HBoxContainer/SkillButton_%s/ProgressBarBackground" % (index + 1)).max_value = selected_skills[index].mana_cost
		index += 1
	
func update_progress_bar():
	var current_mana = $/root/Game/Player.mana_amount
	var index = 0
	for skill in selected_skills:
		if skill != null:
			get_node("MarginContainer/VBoxContainer/HBoxContainer/SkillButton_%s/ProgressBarBackground" % (index + 1)).value = selected_skills[index].mana_cost - current_mana
		index += 1

func show_skill_list():
	print("QuestManager is open = %s" % QuestManager.isOpen)
	if (Game.is_idle && PlayerManager.is_open) || QuestManager.isOpen:
		update_skill_list()
		%SkillAnimationPlayer.play("show_skill_list")
			
func hide_skill_list():
	if %SkillSelection.visible:
		%SkillAnimationPlayer.play("hide_list")


func update_skill_list():
	var index = 0
	for skill in skills:
		if Global.unlocked_skills[skill.identifier]:
			skill.unlocked = true
		%SkillList.set_item_selectable(index, skill.unlocked)
		%SkillList.set_item_disabled(index, !skill.unlocked)
		index += 1

func _on_skill_button_1_pressed():
	if PlayerManager.is_open || QuestManager.isOpen:
		skill_to_update = 0
		show_skill_list()
	else:
		$/root/Game/Player.on_skill_pressed(0)


func _on_skill_button_2_pressed():
	if PlayerManager.is_open || QuestManager.isOpen:
		skill_to_update = 1
		show_skill_list()
	else:
		$/root/Game/Player.on_skill_pressed(1)


func _on_skill_button_3_pressed():
	if PlayerManager.is_open || QuestManager.isOpen:
		skill_to_update = 2
		show_skill_list()
	else:
		$/root/Game/Player.on_skill_pressed(2)


func _on_skill_button_4_pressed():
	if PlayerManager.is_open || QuestManager.isOpen:
		skill_to_update = 3
		show_skill_list()
	else:
		$/root/Game/Player.on_skill_pressed(3)


func _on_player_manager_apply_change():
	update_progress_bar()


func _on_skill_list_item_selected(index):
	selected_skills[skill_to_update] = skills[index]
	update_skills_button_ui()
	hide_skill_list()

# List of Skill
static var skills : Array[Skill] = [
	Skill.new(
	"skill_1",
	10,
	 preload("res://Assets/UI/Skills_button/defense_normal.png"),
	 preload("res://Assets/UI/Skills_button/defense_hover.png"),
	 preload("res://GameElements/defense/defense.tscn"),
	"A defense",
	"defense", true),
	Skill.new(
		"skill_2",
		20,
	 preload("res://Assets/UI/Skills_button/turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/turret_hover.png"),
	 preload("res://GameElements/defense/turret.tscn"),
	"a balanced turret",
	"defense", true),
	Skill.new(
		"skill_3",
		30,
	 preload("res://Assets/UI/Skills_button/aoe_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/aoe_turret_hover.png"),
	 preload("res://GameElements/defense/aoe_turret.tscn"),
	"A turret making aoe damage",
	"defense", false),
	Skill.new(
		"skill_4",
		30,
	 preload("res://Assets/UI/Skills_button/frost_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/frost_turret_hover.png"),
	 preload("res://GameElements/defense/frost_turret.tscn"),
	"A frost turret",
	"defense", false),
	Skill.new(
		"skill_5",
		40,
	 preload("res://Assets/UI/Skills_button/fire_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/fire_turret_hover.png"),
	 preload("res://GameElements/defense/fire_turret.tscn"),
	"A fire turret",
	"defense", false),
	Skill.new(
		"skill_6",
		60,
	 preload("res://Assets/UI/Skills_button/meteor_normal.png"),
	 preload("res://Assets/UI/Skills_button/meteor_hover.png"),
	 preload("res://GameElements/Spells/meteor_bolt.tscn"),
	"A meteor",
	"spell", false),
]



func _on_mouse_entered():
	print("Mouse entered !")
	print("Player Manager is open ? %s" % PlayerManager.is_open)
	if Game.is_on_hub == false && PlayerManager.is_open:
		%LockSkillTexture.visible = true
	else :
		%LockSkillTexture.visible = false
