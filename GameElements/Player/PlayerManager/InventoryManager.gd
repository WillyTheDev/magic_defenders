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
	

func _reset_hat_effect():
	var game = get_node("/root/Game/")
	var lambdas = game.wave_is_over.get_connections()
	for lambda in lambdas:
		game.wave_is_over.disconnect(lambda.callable)
	if has_node("/root/Game/Player/Thunder"):
		$/root/Game/Player/Thunder.queue_free()

func apply_hat():
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
			print("Frost Crown effect applied !")
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
			$/root/Game/Player.add_child(thunder)
			Player.magic_bolt = preload("res://GameElements/Spells/magic_bolt.tscn"),
			"Lightnings will strike ennemies around you",
			preload("res://Assets/hats/hat_6.png")
	),
]

func _on_hat_button_pressed():
	if Game.is_idle:
		load_hat_list()
		%PlayerManagerAnimationPlayer.play("show_hat_list")

func _on_hat_list_item_selected(index):
	Global.player_equipped_hat = index
	apply_hat()
	%PlayerManagerAnimationPlayer.play("hide_hat_list")
	
func load_hat_list():
	%HatList.clear()
	for hat in hats:
		var index = %HatList.add_item(hat.information,hat.texture, true)
		%HatList.set_item_selectable(index, Global.unlocked_hats["hat_%s" % index])
		%HatList.set_item_disabled(index, !Global.unlocked_hats["hat_%s" % index])
		

func apply_loot(previous_loot: Loot, loot:Loot):
	#Removing effect of previous equiped loot
	if previous_loot != loot:
		print("Previous loot = %s" % previous_loot)
		if previous_loot != null:
			Global.inventory.update_equiped_stat(previous_loot.primary_stat, -previous_loot.primary_stat_value)
			Global.inventory.update_equiped_stat(previous_loot.secondary_stat, -previous_loot.secondary_stat_value)
			playerManager.update_stat(previous_loot.primary_stat, 0, true)
			playerManager.update_stat(previous_loot.secondary_stat, 0, true)
			
		#Apply effect of new equiped loot
		print(loot.primary_stat)
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
	%NecklaceList.clear()
	for loot in Global.inventory.loots["necklaces"]:
		var index = %NecklaceList.add_item("%s : %s\n%s: %s" % [get_stat_string(loot.primary_stat), loot.primary_stat_value ,get_stat_string(loot.secondary_stat), loot.secondary_stat_value],loot.texture, true)
		%NecklaceList.set_item_icon_modulate(index, loot.modulate)
		if Global.inventory.equiped_necklaces == loot:
			%NecklaceList.set_item_disabled(index, true)
	Global.inventory.new_loots["necklaces"] = false
	%NecklacesNotification.visible = false
		
func _on_necklace_list_item_selected(index):
	selected_necklaces_index = index
	
func _on_equips_necklaces_pressed():
	if Global.inventory.loots["necklaces"].size() > 0:
		print("Equip selected Necklace : %s" % selected_necklaces_index)
		var previous_loot = Global.inventory.equiped_necklaces
		apply_loot(previous_loot, Global.inventory.loots["necklaces"][selected_necklaces_index])
		Global.inventory.equiped_necklaces = Global.inventory.loots["necklaces"][selected_necklaces_index]
		%PlayerManagerAnimationPlayer.play("hide_necklace_list")
		%SelectedNecklaceTexture.texture = Global.inventory.equiped_necklaces.texture
		%SelectedNecklaceTexture.modulate = Global.inventory.equiped_necklaces.modulate

func _on_delete_necklaces_pressed():
	Global.inventory.loots["necklaces"].remove_at(selected_necklaces_index)
	if Global.inventory.loots["necklaces"].size() > 0:
		selected_necklaces_index = 0
	load_necklace_list()

#========================================
# RINGS
#========================================

func _on_ring_button_pressed():
	load_ring_list()
	%PlayerManagerAnimationPlayer.play("show_ring_list")

func load_ring_list():
	%RingList.clear()
	for loot in Global.inventory.loots["rings"]:
		var index = %RingList.add_item("%s : %s\n%s: %s" % [get_stat_string(loot.primary_stat), loot.primary_stat_value ,get_stat_string(loot.secondary_stat), loot.secondary_stat_value],loot.texture, true)
		%RingList.set_item_icon_modulate(index, loot.modulate)
		if Global.inventory.equiped_rings == loot:
			%RingList.set_item_disabled(index, true)
	Global.inventory.new_loots["rings"] = false
	%RingsNotification.visible = false
			
func _on_ring_list_item_selected(index):
	selected_rings_index = index
	
func _on_equips_rings_pressed():
	if Global.inventory.loots["rings"].size() > 0:
		print(selected_rings_index)
		var previous_loot = Global.inventory.equiped_rings
		apply_loot(previous_loot, Global.inventory.loots["rings"][selected_rings_index])
		Global.inventory.equiped_rings = Global.inventory.loots["rings"][selected_rings_index]
		%PlayerManagerAnimationPlayer.play("hide_ring_list")
		%SelectedRingTexture.texture = Global.inventory.loots["rings"][selected_rings_index].texture
		%SelectedRingTexture.modulate = Global.inventory.loots["rings"][selected_rings_index].modulate

func _on_delete_rings_pressed():
	Global.inventory.loots["rings"].remove_at(selected_rings_index)
	if Global.inventory.loots["rings"].size() > 0:
		selected_rings_index = 0
	load_ring_list()
	
#========================================
# PANTS
#========================================
func _on_pants_button_pressed():
	load_pants_list()
	%PlayerManagerAnimationPlayer.play("show_pants_list")

func load_pants_list():
	%PantsList.clear()
	for loot in Global.inventory.loots["pants"]:
		var index = %PantsList.add_item("%s : %s\n%s: %s" % [get_stat_string(loot.primary_stat), loot.primary_stat_value ,get_stat_string(loot.secondary_stat), loot.secondary_stat_value],loot.texture,true)
		%PantsList.set_item_icon_modulate(index, loot.modulate)
		if Global.inventory.equiped_pants == loot:
			%PantsList.set_item_disabled(index, true)
	Global.inventory.new_loots["pants"] = false
	%PantsNotification.visible = false
	
func _on_pants_list_item_selected(index):
	selected_pants_index = index
	

func _on_equips_pants_pressed():
	if Global.inventory.loots["pants"].size() > 0:
		var previous_loot = Global.inventory.equiped_pants
		apply_loot(previous_loot, Global.inventory.loots["pants"][selected_pants_index])
		Global.inventory.equiped_pants = Global.inventory.loots["pants"][selected_pants_index]
		%PlayerManagerAnimationPlayer.play("hide_pants_list")
		%SelectedPantsTexture.texture = Global.inventory.loots["pants"][selected_pants_index].texture
		%SelectedPantsTexture.modulate = Global.inventory.loots["pants"][selected_pants_index].modulate

func _on_delete_pants_pressed():
	Global.inventory.loots["pants"].remove_at(selected_pants_index)
	if Global.inventory.loots["pants"].size() > 0:
		selected_pants_index = 0
	load_pants_list()
	
#========================================
# PANTS
#========================================

func _on_boots_button_pressed():
	print("boots buttons pressed !")
	load_boots_list()
	%PlayerManagerAnimationPlayer.play("show_boots_list")
	
func load_boots_list():
	%BootsList.clear()
	for loot in Global.inventory.loots["boots"]:
		var index = %BootsList.add_item("%s : %s\n%s: %s" % [get_stat_string(loot.primary_stat), loot.primary_stat_value ,get_stat_string(loot.secondary_stat), loot.secondary_stat_value],loot.texture, true)
		%BootsList.set_item_icon_modulate(index, loot.modulate)
		if Global.inventory.equiped_boots == loot:
			%BootsList.set_item_disabled(index, true)
	Global.inventory.new_loots["boots"] = false
	%BootsNotification.visible = false
	
	
func _on_boots_list_item_selected(index):
	selected_boots_index = index
	
func _on_equips_boots_pressed():
	if Global.inventory.loots["boots"].size() > 0:
		var previous_loot = Global.inventory.equiped_boots
		apply_loot(previous_loot, Global.inventory.loots["boots"][selected_boots_index])
		Global.inventory.equiped_boots = Global.inventory.loots["boots"][selected_boots_index]
		%PlayerManagerAnimationPlayer.play("hide_boots_list")
		%SelectedBootsTexture.texture = Global.inventory.loots["boots"][selected_boots_index].texture
		%SelectedBootsTexture.modulate = Global.inventory.loots["boots"][selected_boots_index].modulate

func _on_delete_boots_pressed():
	Global.inventory.loots["boots"].remove_at(selected_boots_index)
	if Global.inventory.loots["boots"].size() > 0:
		selected_boots_index = 0
	load_boots_list()

func get_stat_string(value: int):
	print("Stat value = %s" % value)
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




















