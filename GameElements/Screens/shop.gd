class_name Shop
extends CanvasLayer

@export var loot_prices = 10
@export var skill_price = 50
static var is_open = false
static var selected_type = 0

func _ready():
	for loot in range(1,5):
		var label = get_node("TextureRect/MarginContainer2/ScrollContainer/VBoxContainer/LootsContainer/item_1_%s/VBoxContainer/MarginContainer2/TextureRect/MarginContainer/Amount" % loot)
		label.text = "%s" % loot_prices
	%PlayerGold.text = "%s" % Global.accumulated_gold
	
	for skill in SkillManager.skills:
		if skill.unlocked == false:
			var skill_item = preload("res://GameElements/Screens/skill_item.tscn").instantiate()
			skill_item.price = skill_price
			skill_item.skill = skill
			skill_item.unlocked_skill.connect(_update_skills)
			%SkillsContainer.add_child(skill_item)
			
func _update_skills():
	get_node("/root/Game/UI/SkillsContainer/VBoxContainer/SkillContainer").update_skill_list()
	get_node("/root/Game/UI").show_available_skill()
	%PlayerGold.text = "%s" % Global.accumulated_gold
	for skill in %SkillsContainer.get_children():
		%SkillsContainer.remove_child(skill)
		skill.queue_free()
	for skill in SkillManager.skills:
		if skill.unlocked == false:
			var skill_item = preload("res://GameElements/Screens/skill_item.tscn").instantiate()
			skill_item.price = skill_price
			skill_item.skill = skill
			skill_item.unlocked_skill.connect(_update_skills)
			%SkillsContainer.add_child(skill_item)

func show_shop():
	is_open = true
	get_tree().paused = true
	%AnimationPlayer.play("show_shop")
	
func close_shop():
	is_open = false
	get_tree().paused = false
	%AnimationPlayer.play("hide_shop")

func _on_item_1_1_pressed():
	if Global.accumulated_gold >= loot_prices:
		selected_type = 1
		_drop_loot()

func _on_item_1_2_pressed():
	if Global.accumulated_gold >= loot_prices:
		selected_type = 0
		_drop_loot()

func _on_item_1_3_pressed():
	if Global.accumulated_gold >= loot_prices:
		selected_type = 2
		_drop_loot()

func _on_item_1_4_pressed():
	if Global.accumulated_gold >= loot_prices:
		selected_type = 3
		_drop_loot()
	
	
	
func _drop_loot():
	Global.accumulated_gold -= loot_prices
	%PlayerGold.text = "%s" % Global.accumulated_gold
	var loot = LootManager.generate_random_loot()
	var loot_to_spawn = preload("res://GameElements/misc/loot.tscn").instantiate()
	loot_to_spawn.is_loot = true
	loot_to_spawn.loot = loot
	loot_to_spawn.get_node("LootSprite").texture = loot.texture
	loot_to_spawn.global_position = get_node("/root/Game/Map/Merchant").global_position + Vector2(randi() % 30, randi() % 30)
	loot_to_spawn.get_node("LootSprite").modulate = loot.modulate
	$/root/Game.call_deferred("add_child", loot_to_spawn)


func _on_back_button_pressed():
	close_shop()
