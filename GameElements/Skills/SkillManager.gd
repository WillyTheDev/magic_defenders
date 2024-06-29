class_name SkillManager
extends Control
# Skills represents Defenses / turrets and spells that the player can use to defend the core.
# Each skill have :
# - Mana cost
# - Skill Button Texture
# - A scene that will be instantiate when the spell is triggered

static var selected_skills : Array[Skill] = [null, null, null, null]

static var skill_to_update = 0
var selected_skill_index = 0

func _ready():
	var player_manager = get_node("/root/Game/PlayerManager")
	player_manager.apply_change.connect(update_skills_button_ui)
	_init_selected_skill()
	update_skill_list()
	update_skills_button_ui()
	

func _init_selected_skill():
	for index in range(0,4):
		selected_skills[index] = skills[Global.selected_skills["skill_%s" % index]]
	for skill in skills:
		if Global.unlocked_skills[skill.identifier]:
			skill.unlocked = true
		var index = %SkillList.add_item(skill.information,skill.texture_normal, skill.unlocked)
		%SkillList.set_item_disabled(index, !skill.unlocked)
	
func update_skills_button_ui():
	var index = 0
	for skill in selected_skills:
		if skill != null:
			var skillButton = get_node("MarginContainer/VBoxContainer/HBoxContainer/SkillButton_%s" % (index + 1))
			skillButton.texture_normal = selected_skills[index].texture_normal
			skillButton.texture_hover = selected_skills[index].texture_hover
			skillButton.texture_focused = selected_skills[index].texture_focused
			var infoSkillIconTexture = get_node("CanvasLayer/InfoContainerSkill_%s/TextureRect/HBoxContainer/MarginContainer/InfoIconTexture" % (index + 1))
			infoSkillIconTexture.texture = selected_skills[index].icon_texture
			var infoSkillRichLabel = get_node("CanvasLayer/InfoContainerSkill_%s/TextureRect/HBoxContainer/MarginContainer2/InfoRichLabel" % (index + 1))
			
			infoSkillRichLabel.text = "- [color=purple] %s [/color] -
%s
Mana cost : [color=RoyalBlue] %s [/color]" % [selected_skills[index].profession,selected_skills[index].information,selected_skills[index].mana_cost]
			print(infoSkillRichLabel.text)
			get_node("MarginContainer/VBoxContainer/HBoxContainer/SkillButton_%s/ProgressBarBackground" % (index + 1)).max_value = selected_skills[index].mana_cost
			if Global.player_using_controller:
				get_node("MarginContainer/VBoxContainer/HBoxContainer/SkillButton_%s/Label" % (index + 1)).text = "[center][img=30x30]res://Assets/UI/input/cross_%s.png[/img][/center]" % (index + 1)
			
		index += 1
	
func update_progress_bar():
	var current_mana = Player.mana_amount
	var index = 0
	for skill in selected_skills:
		if skill != null:
			get_node("MarginContainer/VBoxContainer/HBoxContainer/SkillButton_%s/ProgressBarBackground" % (index + 1)).value = selected_skills[index].mana_cost - current_mana
		index += 1

func show_skill_list():
	print("QuestManager is open = %s" % QuestManager.is_open)
	if  QuestManager.is_open || ChallengeManager.is_open:
		update_skill_list()
		%SkillAnimationPlayer.play("show_skill_list")
		if Global.player_using_controller:
			await %SkillAnimationPlayer.animation_finished
			%SkillList.grab_focus()
		
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
	if PlayerManager.is_open || QuestManager.is_open || ChallengeManager.is_open:
		skill_to_update = 0
		show_skill_list()
	else:
		$/root/Game/Player.on_skill_pressed(0)


func _on_skill_button_2_pressed():
	if PlayerManager.is_open || QuestManager.is_open || ChallengeManager.is_open:
		skill_to_update = 1
		show_skill_list()
	else:
		$/root/Game/Player.on_skill_pressed(1)


func _on_skill_button_3_pressed():
	if PlayerManager.is_open || QuestManager.is_open || ChallengeManager.is_open:
		skill_to_update = 2
		show_skill_list()
	else:
		$/root/Game/Player.on_skill_pressed(2)


func _on_skill_button_4_pressed():
	if PlayerManager.is_open || QuestManager.is_open || ChallengeManager.is_open:
		skill_to_update = 3
		show_skill_list()
	else:
		$/root/Game/Player.on_skill_pressed(3)

func _on_player_manager_apply_change():
	update_progress_bar()
	
# This will support controller action
func _on_skill_list_item_activated(index):
	print("Item activated !")
	selected_skills[skill_to_update] = skills[index]
	Global.selected_skills["skill_%s" % skill_to_update] = index
	update_skills_button_ui()
	hide_skill_list()


# List of Skill
static var skills : Array[Skill] = [
	Skill.new(
	"skill_1",
	10,
	 preload("res://Assets/UI/Skills_button/defense_normal.png"),
	 preload("res://Assets/UI/Skills_button/defense_hover.png"),
	 preload("res://Assets/UI/Skills_button/defense_focused.png"),
	 preload("res://Assets/UI/Skills_button/defense_icon.png"),
	 preload("res://GameElements/defense/defense.tscn"),
	"The most simple defense, it will block the ennemies until it's been destroyed",
	"defense",
	"Mage",
	 true),
	Skill.new(
		"skill_2",
		20,
	 preload("res://Assets/UI/Skills_button/turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/turret_hover.png"),
	 preload("res://Assets/UI/Skills_button/turret_focused.png"),
	 preload("res://Assets/UI/Skills_button/turret_icon.png"),
	 preload("res://GameElements/defense/turret.tscn"),
	"This turret will shoot ennemies, it's really fragile",
	"defense",
	"Mage",
	true),
	Skill.new(
		"skill_3",
		40,
	 preload("res://Assets/UI/Skills_button/aoe_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/aoe_turret_hover.png"),
	 preload("res://Assets/UI/Skills_button/aoe_turret_focused.png"),
	 preload("res://Assets/UI/Skills_button/aoe_turret_icon.png"),
	 preload("res://GameElements/defense/aoe_turret.tscn"),
	"This turret will create explosions around it",
	"defense",
	"Mage",
	 false),
	Skill.new(
		"skill_4",
		30,
	 preload("res://Assets/UI/Skills_button/frost_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/frost_turret_hover.png"),
	 preload("res://Assets/UI/Skills_button/frost_turret_focused.png"),
	 preload("res://Assets/UI/Skills_button/frost_turret_icon.png"),
	 preload("res://GameElements/defense/frost_turret.tscn"),
	"This turret will slown down nearby ennemies",
	"defense",
	"Mage",
	 false),
	Skill.new(
		"skill_5",
		40,
	 preload("res://Assets/UI/Skills_button/fire_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/fire_turret_hover.png"),
	 preload("res://Assets/UI/Skills_button/fire_turret_focused.png"),
	 preload("res://Assets/UI/Skills_button/turret_fire_icon.png"),
	 preload("res://GameElements/defense/fire_turret.tscn"),
	"This turret will inflict a lot of damage and burn the ennemies",
	"defense",
	"Mage",
	false),
	Skill.new(
		"skill_6",
		60,
	 preload("res://Assets/UI/Skills_button/meteor_normal.png"),
	 preload("res://Assets/UI/Skills_button/meteor_hover.png"),
	 preload("res://Assets/UI/Skills_button/meteor_focused.png"),
	 preload("res://Assets/UI/Skills_button/meteor_icon.png"),
	 preload("res://GameElements/Spells/meteor_bolt.tscn"),
	"This spell will inflict huge damages after a delay",
	"spell",
	"Mage", false),
	Skill.new(
		"skill_7",
		15,
	 preload("res://Assets/UI/Skills_button/spiked_defense_normal.png"),
	 preload("res://Assets/UI/Skills_button/spiked_defense_hover.png"),
	 preload("res://Assets/UI/Skills_button/spiked_defense_focused.png"),
	 preload("res://Assets/UI/Skills_button/spiked_defense_icon.png"),
	 preload("res://GameElements/defense/spiked_defense.tscn"),
	"This defense will inflict damage to ennemies attacking it",
	"defense",
	"Warrior",
	false),
	Skill.new(
		"skill_8",
		30,
	 preload("res://Assets/UI/Skills_button/vision_turret_normal.png"),
	 preload("res://Assets/UI/Skills_button/vision_turret_hover.png"),
	 preload("res://Assets/UI/Skills_button/vision_turret_focused.png"),
	 preload("res://Assets/UI/Skills_button/vision_turret_icon.png"),
	 preload("res://GameElements/defense/vision_turret.tscn"),
	"A turret that reveals untargetable ennemies and reduce the ennemy damage",
	"defense",
	"Priest", false),
	Skill.new(
		"skill_9",
		30,
	 preload("res://Assets/UI/Skills_button/baliste_normal.png"),
	 preload("res://Assets/UI/Skills_button/baliste_hover.png"),
	 preload("res://Assets/UI/Skills_button/baliste_focused.png"),
	 preload("res://Assets/UI/Skills_button/baliste_icon.png"),
	 preload("res://GameElements/defense/baliste.tscn"),
	"A turret that shot piercing arrow",
	"defense",
	"Warrior",
	false),
]


func _on_skill_animation_player_animation_finished(anim_name):
	if anim_name == "hide_list" && Global.player_using_controller:
		print("Hiding List triggered : SKill to focus = %s" % (skill_to_update + 1))
		get_node("MarginContainer/VBoxContainer/HBoxContainer/SkillButton_%s" % (skill_to_update + 1)).grab_focus()


func _on_skill_button_1_mouse_entered():
	$CanvasLayer/InfoContainerSkill_1.visible = true
	
func _on_skill_button_1_mouse_exited():
	$CanvasLayer/InfoContainerSkill_1.visible = false


func _on_skill_button_2_mouse_entered():
	$CanvasLayer/InfoContainerSkill_2.visible = true


func _on_skill_button_2_mouse_exited():
	$CanvasLayer/InfoContainerSkill_2.visible = false


func _on_skill_button_3_mouse_entered():
	$CanvasLayer/InfoContainerSkill_3.visible = true

func _on_skill_button_3_mouse_exited():
	$CanvasLayer/InfoContainerSkill_3.visible = false


func _on_skill_button_4_mouse_entered():
	$CanvasLayer/InfoContainerSkill_4.visible = true


func _on_skill_button_4_mouse_exited():
	$CanvasLayer/InfoContainerSkill_4.visible = false
