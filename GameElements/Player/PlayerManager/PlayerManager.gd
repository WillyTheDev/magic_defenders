class_name PlayerManager
extends CanvasLayer


var playerhasLeveledUp : bool = false

func _ready():
	for index in range(1,6):
		print(index)
		var label = get_node("Background/MarginContainer/VBoxContainer/stat_%s/VBoxContainer/label_stat_%s" % [index,index])
		var progress = get_node("Background/MarginContainer/VBoxContainer/stat_%s/VBoxContainer2/MarginContainer/Progress_stat_%s" % [index,index])
		label.text = "%s" % Global.getStatFromIndex(index)
		progress.value = Global.getStatFromIndex(index)
	for index in range(Global.unlocked_hats.size()):
		if Global.unlocked_hats[index]:
			%HatList.items[index].selectable = true
			%HatList.items[index].disabled = false
	
func show_player_profile():
	%LevelLabel.text = "Level : %s" % Global.player_level
	%AvailPtsLabel.text = "Available points : %s" % Global.player_avail_pts
	get_tree().paused = true
	playerhasLeveledUp = true
	%PlayerProfileTimer.start()
	%PlayerManagerAnimationPlayer.play("show_player_profile")
	print(Game.is_idle)
	if Game.is_idle == false:
		%HatButton.disabled = true
		%HatButton.texture_normal = load("res://Assets/UI/player_profile_background/hat_button_locked.png")
	else:
		%HatButton.disabled = false
		%HatButton.texture_normal = load("res://Assets/UI/player_profile_background/hat_button.png")
	visible = true
	
func hide_player_profile():
	%PlayerManagerAnimationPlayer.play("hide_player_profile")
	get_tree().paused = false
	playerhasLeveledUp = false
	

func _input(event):
	if event.is_action_pressed("show_player_profile"):
		print("Show player profile !")
		if visible == true:
			hide_player_profile()
		else:
			show_player_profile()

signal turret_modified

signal defense_modified

signal enemy_modified

signal player_modified

func apply_player_modification(args : Callable):
	player_modified.emit(args)

func apply_enemy_modification(args : Callable):
	enemy_modified.emit(args)

func apply_turret_modification(args: Callable):
	turret_modified.emit(args)

func apply_defense_modification(args: Callable):
	defense_modified.emit(args)

func update_stat(stat_index : int, increment_value : int):
	if increment_value < 0:
		if Global.getStatFromIndex(stat_index) > 0:
			print(stat_index)
			var label = get_node("Background/MarginContainer/VBoxContainer/stat_%s/VBoxContainer/label_stat_%s" % [stat_index,stat_index])
			var progress = get_node("Background/MarginContainer/VBoxContainer/stat_%s/VBoxContainer2/MarginContainer/Progress_stat_%s" % [stat_index,stat_index])
			Global.setStatFromIndex(stat_index, increment_value)
			label.text = "%s" % Global.getStatFromIndex(stat_index)
			progress.value = Global.getStatFromIndex(stat_index)
			Global.player_avail_pts += 1
	elif Global.player_avail_pts > 0:
		print(stat_index)
		var label = get_node("Background/MarginContainer/VBoxContainer/stat_%s/VBoxContainer/label_stat_%s" % [stat_index,stat_index])
		var progress = get_node("Background/MarginContainer/VBoxContainer/stat_%s/VBoxContainer2/MarginContainer/Progress_stat_%s" % [stat_index,stat_index])
		Global.setStatFromIndex(stat_index, increment_value)
		label.text = "%s" % Global.getStatFromIndex(stat_index)
		progress.value = Global.getStatFromIndex(stat_index)
		Global.player_avail_pts -= 1
	%AvailPtsLabel.text = "Available points : %s" % Global.player_avail_pts



# =============================
# PLAYER PROFILE BUTTON PRESSED
# =============================

func _on_apply_pressed():
	hide_player_profile()

func _on_add_stat_5_pressed():
	update_stat(5, 1)

func _on_remove_stat_5_pressed():
	update_stat(5, -1)

func _on_add_stat_4_pressed():
	update_stat(4, 1)

func _on_remove_stat_4_pressed():
	update_stat(4, -1)

func _on_add_stat_3_pressed():
	update_stat(3, 1)

func _on_remove_stat_3_pressed():
	update_stat(3, -1)

func _on_add_stat_2_pressed():
	update_stat(2, 1)

func _on_remove_stat_2_pressed():
	update_stat(2, -1)

func _on_add_stat_1_pressed():
	update_stat(1, 1)

func _on_remove_stat_1_pressed():
	update_stat(1, -1)

func _on_hat_button_pressed():
	%HatList.visible = true

func apply_hat():
	if Global.player_equipped_hat != 99:
		var playerAnimation = get_node("/root/Game/Player/PlayerAnimation")
		playerAnimation.setHat(Global.player_equipped_hat)
		%PlayerPreview.setHat(Global.player_equipped_hat)
		_reset_hat_effect()
		_apply_hat_effect()
		%HatDescription.text = hats[Global.player_equipped_hat].information
		%SelectedHatTexture.texture = load("res://Assets/hats/hat_%s.png" % Global.player_equipped_hat)
		%HatList.visible = false

func _on_hat_list_item_clicked(index, at_position, mouse_button_index):
	Global.player_equipped_hat = index
	apply_hat()
	
var hats : Array[Hat] = [
	Hat.new(
		func():
			MagicBolt.has_auto_target_on = true
			MagicBolt.range = 1000
			MagicBolt.texture = load("res://Assets/Player/water_bolt.png"),
			"Projectiles ricochet between enemies."
		),
	Hat.new(
		func():
			MagicBolt.is_reducing_speed = true
			MagicBolt.texture = load("res://Assets/Player/frost_bolt.png"),
			"Projectiles slow down enemies."
		),
	Hat.new(
		func():
			MagicBolt.is_passing_through = true
			MagicBolt.texture = load("res://Assets/Player/bouncing_bolt.png"),
			"Projectiles pass through enemies."
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
			"Heals all defenses on the end of a wave"
		),
]

func _apply_hat_effect():
	hats[Global.player_equipped_hat].apply_effect()

func _reset_hat_effect():
	MagicBolt.has_auto_target_on = false
	MagicBolt.is_reducing_speed = false
	MagicBolt.is_passing_through = false
	MagicBolt.texture = load("res://Assets/Player/fire_bolt.png")
	MagicBolt.range = 1600
	var game = get_node("/root/Game/")
	var lambdas = game.wave_is_over.get_connections()
	for lambda in lambdas:
		game.wave_is_over.disconnect(lambda.callable)

func _on_player_manager_animation_player_animation_finished(anim_name):
	if anim_name == "hide_player_profile":
		visible = false
