extends Control

@onready var playerManager = get_parent()
var selected_necklaces_index = 0
var selected_rings_index = 0
var selected_pants_index = 0
var selected_boots_index = 0

func _ready():
	if Global.inventory.equiped_necklaces != null:
		%SelectedNecklaceTexture.texture = Global.inventory.equiped_necklaces.texture
		%SelectedNecklaceTexture.modulate = Global.inventory.equiped_necklaces.modulate
	if Global.inventory.equiped_rings != null:
		%SelectedRingTexture.texture = Global.inventory.equiped_rings.texture
		%SelectedRingTexture.modulate = Global.inventory.equiped_rings.modulate
	if Global.inventory.equiped_pants != null:
		%SelectedPantsTexture.texture = Global.inventory.equiped_pants.texture
		%SelectedPantsTexture.modulate = Global.inventory.equiped_pants.modulate
	if Global.inventory.equiped_boots != null:
		%SelectedBootsTexture.texture = Global.inventory.equiped_boots.texture
		%SelectedBootsTexture.modulate = Global.inventory.equiped_boots.modulate
	%GoldLabel.text = "%s" % Global.accumulated_gold
	

func _reset_hat_effect():
	var game = get_node("/root/Game/")
	Player.magic_bolt = preload("res://GameElements/Spells/magic_bolt.tscn")
	var lambdas = game.wave_is_over.get_connections()
	for lambda in lambdas:
		game.wave_is_over.disconnect(lambda.callable)
	if has_node("/root/Game/Player/Thunder"):
		$/root/Game/Player/Thunder.queue_free()

func apply_hat(index):
	Global.player_equipped_hat = index
	if Global.player_equipped_hat != 99:
		var playerAnimation = get_node("/root/Game/Player/PlayerAnimation")
		playerAnimation.setHat(Global.player_equipped_hat)
		%PlayerPreview.setHat(Global.player_equipped_hat)
		_reset_hat_effect()
		hats[Global.player_equipped_hat].apply_effect()
		%SelectedHatTexture.texture = load("res://Assets/hats/hat_%s.png" % Global.player_equipped_hat)



var hats : Array[Hat] = [
	Hat.new(
		func():
			Player.magic_bolt = preload("res://GameElements/Spells/frost_bolt.tscn"),
			"Projectiles slow down enemies but the damages are divide by 2",
			preload("res://Assets/hats/hat_0.png")
		),
	Hat.new(
		func():
			Player.magic_bolt = preload("res://GameElements/Spells/ghost_bolt.tscn"),
			"Projectiles pass through enemies.",
			preload("res://Assets/hats/hat_1.png"),
		),
	Hat.new(
		func():
			pass,
			"Just a nice looking hat to make your life more playful",
			preload("res://Assets/hats/hat_2.png")
		),
	Hat.new(
		func():
			var lambda = func heal_defenses():
				var game = get_node("/root/Game/")
				var children = game.get_children()
				for child in children:
					if child is Defense:
						child.heal_defense(100)
			var game = get_node("/root/Game/")
			game.wave_is_over.connect(lambda)
			,
			"Heals all defenses on the end of a wave",
			preload("res://Assets/hats/hat_3.png")
		),
	Hat.new(
	func():
			Player.magic_bolt = preload("res://GameElements/Spells/fire_bolt.tscn"),
			"Projectiles is burning the enemy until they die",
			preload("res://Assets/hats/hat_4.png")
	),
	Hat.new(
	func():
			Player.magic_bolt = preload("res://GameElements/Spells/MerlinBolt.tscn"),
			"Projectiles is exploding !",
			preload("res://Assets/hats/hat_5.png")
	),
	Hat.new(
	func():
			var thunder = preload("res://GameElements/Spells/thunder.tscn").instantiate()
			$/root/Game/Player.add_child(thunder,true)
			Player.magic_bolt = preload("res://GameElements/Spells/magic_bolt.tscn"),
			"Lightnings will strike ennemies around you",
			preload("res://Assets/hats/hat_6.png")
	),
]

func _on_hat_button_pressed():
	if Game.is_idle:
		load_hat_list()
		%PlayerManagerAnimationPlayer.play("show_hat_list")
	
func load_hat_list():
	for child in %GridHat.get_children():
		child.queue_free()
	var index = 0
	for key in Global.unlocked_hats:
		if Global.unlocked_hats[key]:
			print("Unlocked hat : %s  \n and description : %s " % [index,hats[index].information])
			var loot_to_show = preload("res://loot_item.tscn").instantiate()
			loot_to_show.is_hat = true
			loot_to_show.hat_description = hats[index].information
			loot_to_show.loot_texture = hats[index].texture
			loot_to_show.loot_index = index
			loot_to_show.loot_item_equip_pressed.connect(apply_hat)
			%GridHat.add_child(loot_to_show)
		index += 1
	if Global.player_using_controller:
		await %PlayerManagerAnimationPlayer.animation_finished
		%GridHat.get_child(0).grab_focus()
		
func apply_loot(previous_loot: Loot, loot:Loot):
	#Removing effect of previous equiped loot
	if previous_loot != loot:
		if previous_loot != null:
			Global.inventory.update_equiped_stat(previous_loot.primary_stat, -previous_loot.primary_stat_value)
			Global.inventory.update_equiped_stat(previous_loot.secondary_stat, -previous_loot.secondary_stat_value)
			playerManager.update_stat(previous_loot.primary_stat, 0, true)
			playerManager.update_stat(previous_loot.secondary_stat, 0, true)
			
		#Apply effect of new equiped loot
		Global.inventory.update_equiped_stat(loot.primary_stat, loot.primary_stat_value)
		Global.inventory.update_equiped_stat(loot.secondary_stat, loot.secondary_stat_value)
		playerManager.update_stat(loot.primary_stat, 0, true)
		playerManager.update_stat(loot.secondary_stat, 0, true)

#========================================
# NECKLACES
#========================================
func _on_necklace_button_pressed():
	load_necklace_list()
	%PlayerManagerAnimationPlayer.play("show_necklace_list")
	
func load_necklace_list():
	var index = 0
	for child in %GridNecklace.get_children():
		child.queue_free()
	for loot in Global.inventory.loots["necklaces"]:
		var loot_to_show = preload("res://loot_item.tscn").instantiate()
		loot_to_show.loot_texture = loot.texture
		loot_to_show.stat_texture = preload("res://Assets/loots/necklaces_stat.png")
		loot_to_show.loot_primary_stat = get_stat_string(loot.primary_stat)
		loot_to_show.loot_primary_stat_value = loot.primary_stat_value
		loot_to_show.loot_secondary_stat = get_stat_string(loot.secondary_stat)
		loot_to_show.loot_secondary_stat_value = loot.secondary_stat_value
		loot_to_show.loot_rarity = loot.rarity
		loot_to_show.loot_index = index
		loot_to_show.loot_item_equip_pressed.connect(_on_equips_necklaces_pressed)
		loot_to_show.loot_item_sell_pressed.connect(_on_delete_necklaces_pressed)
		if Global.inventory.equiped_necklaces == loot:
			loot_to_show.is_equiped = true
		%GridNecklace.add_child(loot_to_show)
		index += 1
	Global.inventory.new_loots["necklaces"] = false
	%NecklacesNotification.visible = false
	if Global.player_using_controller:
		await %PlayerManagerAnimationPlayer.animation_finished
		%GridNecklace.get_child(0).grab_focus()
		



func _on_equips_necklaces_pressed(index):
	if Global.inventory.loots["necklaces"].size() > 0:
		var previous_loot = Global.inventory.equiped_necklaces
		apply_loot(previous_loot, Global.inventory.loots["necklaces"][index])
		Global.inventory.equiped_necklaces = Global.inventory.loots["necklaces"][index]
		%PlayerManagerAnimationPlayer.play("hide_necklace_list")
		%SelectedNecklaceTexture.texture = Global.inventory.equiped_necklaces.texture
		%SelectedNecklaceTexture.modulate = Global.inventory.equiped_necklaces.modulate

func _on_delete_necklaces_pressed(index):
	Global.accumulated_gold += (1+Global.inventory.loots["necklaces"][index].rarity)
	Global.inventory.loots["necklaces"].remove_at(index)
	if Global.inventory.loots["necklaces"].size() > 0:
		selected_necklaces_index = 0
	%GoldLabel.text = "%s" % Global.accumulated_gold
	%SellingAudio.play()
	load_necklace_list()

#========================================
# RINGS
#========================================

func _on_ring_button_pressed():
	load_ring_list()
	%PlayerManagerAnimationPlayer.play("show_ring_list")

func load_ring_list():
	var index = 0
	for child in %GridRings.get_children():
		child.queue_free()
	for loot in Global.inventory.loots["rings"]:
		var loot_to_show = preload("res://loot_item.tscn").instantiate()
		loot_to_show.loot_texture = loot.texture
		loot_to_show.stat_texture = preload("res://Assets/loots/rings_stat.png")
		loot_to_show.loot_primary_stat = get_stat_string(loot.primary_stat)
		loot_to_show.loot_primary_stat_value = loot.primary_stat_value
		loot_to_show.loot_secondary_stat = get_stat_string(loot.secondary_stat)
		loot_to_show.loot_secondary_stat_value = loot.secondary_stat_value
		loot_to_show.loot_rarity = loot.rarity
		loot_to_show.loot_index = index
		loot_to_show.loot_item_equip_pressed.connect(_on_equips_rings_pressed)
		loot_to_show.loot_item_sell_pressed.connect(_on_delete_rings_pressed)
		if Global.inventory.equiped_rings == loot:
			loot_to_show.is_equiped = true
		%GridRings.add_child(loot_to_show)
		index += 1
	Global.inventory.new_loots["rings"] = false
	%RingsNotification.visible = false
	if Global.player_using_controller:
		await %PlayerManagerAnimationPlayer.animation_finished
		%GridRings.get_child(0).grab_focus()

func _on_equips_rings_pressed(index):
	if Global.inventory.loots["rings"].size() > 0:
		var previous_loot = Global.inventory.equiped_rings
		apply_loot(previous_loot, Global.inventory.loots["rings"][index])
		Global.inventory.equiped_rings = Global.inventory.loots["rings"][index]
		%PlayerManagerAnimationPlayer.play("hide_ring_list")
		%SelectedRingTexture.texture = Global.inventory.loots["rings"][index].texture
		%SelectedRingTexture.modulate = Global.inventory.loots["rings"][index].modulate

func _on_delete_rings_pressed(index):
	Global.accumulated_gold += (1+Global.inventory.loots["rings"][index].rarity)
	Global.inventory.loots["rings"].remove_at(index)
	if Global.inventory.loots["rings"].size() > 0:
		selected_rings_index = 0
	load_ring_list()
	%SellingAudio.play()
	%GoldLabel.text = "%s" % Global.accumulated_gold
	
#========================================
# PANTS
#========================================
func _on_pants_button_pressed():
	load_pants_list()
	%PlayerManagerAnimationPlayer.play("show_pants_list")

func load_pants_list():
	var index = 0
	for child in %GridPants.get_children():
		child.queue_free()
	for loot in Global.inventory.loots["pants"]:
		var loot_to_show = preload("res://loot_item.tscn").instantiate()
		loot_to_show.loot_texture = loot.texture
		loot_to_show.stat_texture = preload("res://Assets/loots/pants_stats.png")
		loot_to_show.loot_primary_stat = get_stat_string(loot.primary_stat)
		loot_to_show.loot_primary_stat_value = loot.primary_stat_value
		loot_to_show.loot_secondary_stat = get_stat_string(loot.secondary_stat)
		loot_to_show.loot_secondary_stat_value = loot.secondary_stat_value
		loot_to_show.loot_rarity = loot.rarity
		loot_to_show.loot_index = index
		loot_to_show.loot_item_equip_pressed.connect(_on_equips_pants_pressed)
		loot_to_show.loot_item_sell_pressed.connect(_on_delete_pants_pressed)
		if Global.inventory.equiped_pants == loot:
			loot_to_show.is_equiped = true
		%GridPants.add_child(loot_to_show)
		index += 1
	Global.inventory.new_loots["pants"] = false
	%PantsNotification.visible = false
	if Global.player_using_controller:
		await %PlayerManagerAnimationPlayer.animation_finished
		%GridPants.get_child(0).grab_focus()

func _on_equips_pants_pressed(index):
	print("equip pants on index : %s" % index)
	if Global.inventory.loots["pants"].size() > 0:
		var previous_loot = Global.inventory.equiped_pants
		apply_loot(previous_loot, Global.inventory.loots["pants"][index])
		Global.inventory.equiped_pants = Global.inventory.loots["pants"][index]
		%PlayerManagerAnimationPlayer.play("hide_pants_list")
		%SelectedPantsTexture.texture = Global.inventory.loots["pants"][index].texture
		%SelectedPantsTexture.modulate = Global.inventory.loots["pants"][index].modulate

func _on_delete_pants_pressed(index):
	Global.accumulated_gold += (1+Global.inventory.loots["pants"][index].rarity)
	Global.inventory.loots["pants"].remove_at(index)
	if Global.inventory.loots["pants"].size() > 0:
		selected_pants_index = 0
	load_pants_list()
	%SellingAudio.play()
	%GoldLabel.text = "%s" % Global.accumulated_gold
	
#========================================
# PANTS
#========================================

func _on_boots_button_pressed():
	load_boots_list()
	%PlayerManagerAnimationPlayer.play("show_boots_list")
	
func load_boots_list():
	var index = 0
	for child in %GridBoots.get_children():
		child.queue_free()
	for loot in Global.inventory.loots["boots"]:
		var loot_to_show = preload("res://loot_item.tscn").instantiate()
		loot_to_show.loot_texture = loot.texture
		loot_to_show.stat_texture = preload("res://Assets/loots/boots_Stat.png")
		loot_to_show.loot_primary_stat = get_stat_string(loot.primary_stat)
		loot_to_show.loot_primary_stat_value = loot.primary_stat_value
		loot_to_show.loot_secondary_stat = get_stat_string(loot.secondary_stat)
		loot_to_show.loot_secondary_stat_value = loot.secondary_stat_value
		loot_to_show.loot_rarity = loot.rarity
		loot_to_show.loot_index = index
		loot_to_show.loot_item_equip_pressed.connect(_on_equips_boots_pressed)
		loot_to_show.loot_item_sell_pressed.connect(_on_delete_boots_pressed)
		if Global.inventory.equiped_boots == loot:
			loot_to_show.is_equiped = true
		%GridBoots.add_child(loot_to_show)
		index += 1
	Global.inventory.new_loots["boots"] = false
	%BootsNotification.visible = false
	if Global.player_using_controller:
		await %PlayerManagerAnimationPlayer.animation_finished
		%GridBoots.get_child(0).grab_focus()

func _on_equips_boots_pressed(index):
	if Global.inventory.loots["boots"].size() > 0:
		var previous_loot = Global.inventory.equiped_boots
		apply_loot(previous_loot, Global.inventory.loots["boots"][selected_boots_index])
		Global.inventory.equiped_boots = Global.inventory.loots["boots"][selected_boots_index]
		%PlayerManagerAnimationPlayer.play("hide_boots_list")
		%SelectedBootsTexture.texture = Global.inventory.loots["boots"][selected_boots_index].texture
		%SelectedBootsTexture.modulate = Global.inventory.loots["boots"][selected_boots_index].modulate

func _on_delete_boots_pressed(index):
	Global.accumulated_gold += (1+Global.inventory.loots["boots"][index].rarity)
	Global.inventory.loots["boots"].remove_at(index)
	if Global.inventory.loots["boots"].size() > 0:
		selected_boots_index = 0
	load_boots_list()
	%SellingAudio.play()
	%GoldLabel.text = "%s" % Global.accumulated_gold

func get_stat_string(value: int):
	match value:
		1:
			return "player damage"
		2:
			return "defense range"
		3:
			return "defense damage"
		4:
			return "defense health"
		5:
			return "defense Attack speed"

func show_notifications():
	if Global.inventory.new_loots["necklaces"]:
		%NecklacesNotification.visible = true
	if Global.inventory.new_loots["rings"]:
		%RingsNotification.visible = true
	if Global.inventory.new_loots["pants"]:
		%PantsNotification.visible = true
	if Global.inventory.new_loots["boots"]:
		%BootsNotification.visible = true



