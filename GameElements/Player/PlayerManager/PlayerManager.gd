class_name PlayerManager
extends CanvasLayer


var playerhasLeveledUp : bool = false
static var is_open = false
signal apply_change

func _ready():
	for index in range(1,6):
		var label = get_node("StatsContainer/VBoxContainer/stat_%s/VBoxContainer/label_stat_%s" % [index,index])
		var progress = get_node("StatsContainer/VBoxContainer/stat_%s/VBoxContainer2/MarginContainer/Progress_stat_%s" % [index,index])
		label.text = "%s" % Global.getTotalStatFromIndex(index)
		progress.value = Global.getTotalStatFromIndex(index)
	
func show_player_profile():
	%LevelLabel.text = "Level : %s" % Global.player_level
	%AvailPtsLabel.text = "Available points : %s" % Global.player_avail_pts
	get_tree().paused = true
	playerhasLeveledUp = true
	%PlayerProfileTimer.start()
	%PlayerManagerAnimationPlayer.play("show_player_profile")
	$/root/Game/UI.hide_available_skill()
	visible = true
	is_open = true
	%InventoryManager.show_notifications()
	
func hide_player_profile():
	%PlayerManagerAnimationPlayer.play("hide_player_profile")
	get_tree().paused = false
	playerhasLeveledUp = false
	

func _input(event):
	if event.is_action_pressed("show_player_profile"):
		if visible == true:
			hide_player_profile()
			apply_change.emit()
		else:
			show_player_profile()


signal player_has_available_point

func update_stat(stat_index : int, increment_value : int, loot_change : bool):
	if increment_value < 0:
		if Global.getStatFromIndex(stat_index) > 0:
			var label = get_node("StatsContainer/VBoxContainer/stat_%s/VBoxContainer/label_stat_%s" % [stat_index,stat_index])
			var progress = get_node("StatsContainer/VBoxContainer/stat_%s/VBoxContainer2/MarginContainer/Progress_stat_%s" % [stat_index,stat_index])
			Global.setStatFromIndex(stat_index, increment_value)
			label.text = "%s" % Global.getTotalStatFromIndex(stat_index)
			progress.value = Global.getTotalStatFromIndex(stat_index)
			if loot_change == false:
				Global.player_avail_pts += 1
	elif (Global.player_avail_pts > 0 && Global.getTotalStatFromIndex(stat_index) < 100) || loot_change:
		var label = get_node("StatsContainer/VBoxContainer/stat_%s/VBoxContainer/label_stat_%s" % [stat_index,stat_index])
		var progress = get_node("StatsContainer/VBoxContainer/stat_%s/VBoxContainer2/MarginContainer/Progress_stat_%s" % [stat_index,stat_index])
		Global.setStatFromIndex(stat_index, increment_value)
		label.text = "%s" % Global.getTotalStatFromIndex(stat_index)
		progress.value = Global.getTotalStatFromIndex(stat_index)
		if loot_change == false:
			Global.player_avail_pts -= 1
			if Global.player_avail_pts == 0:
				player_has_available_point.emit(false)
			else :
				player_has_available_point.emit(true)
	%AvailPtsLabel.text = "Available points : %s" % Global.player_avail_pts



# =============================
# PLAYER PROFILE BUTTON PRESSED
# =============================

func _on_apply_pressed():
	apply_change.emit()
	hide_player_profile()

func _on_add_stat_5_pressed():
	update_stat(5, 1, false)

func _on_remove_stat_5_pressed():
	update_stat(5, -1, false)

func _on_add_stat_4_pressed():
	update_stat(4, 1, false)

func _on_remove_stat_4_pressed():
	update_stat(4, -1, false)

func _on_add_stat_3_pressed():
	update_stat(3, 1, false)

func _on_remove_stat_3_pressed():
	update_stat(3, -1, false)

func _on_add_stat_2_pressed():
	update_stat(2, 1, false)

func _on_remove_stat_2_pressed():
	update_stat(2, -1, false)

func _on_add_stat_1_pressed():
	update_stat(1, 1, false)

func _on_remove_stat_1_pressed():
	update_stat(1, -1, false)

func _on_player_manager_animation_player_animation_finished(anim_name):
	if anim_name == "hide_player_profile":
		visible = false


