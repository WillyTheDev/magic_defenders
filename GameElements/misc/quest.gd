class_name Quest
extends TextureButton

enum reward_type {GOLD}

var difficulty = 1
var waves_to_completed : int = 10
var texture_reward : Texture = null
var map_texture_normal : Texture = null
var map_texture_hover : Texture = null
var map_texture_clicked : Texture = null
var map_of_quest_index : int = 0
var is_day : bool = true
var reward : reward_type = reward_type.GOLD
var is_urgent : bool = false
var enemy_sequence : Array[String] = [""]
var required_quests_completed : int = 0
var has_been_completed : bool = false
var gold_amount : int = 10
var has_been_pressed = false

func _ready():
	$/root/Game/TransitionLayer.transition_is_finished.connect(_on_transition_layer_transition_is_finished)
	for value in range(1,difficulty + 1):
		get_node("DifficultyContainer/Difficulty/difficulty_%s" % value).texture = preload("res://Assets/UI/map_selection_button/difficulty_indicator_fill.png")
	%ConditionLabel.text = "You must survive %s waves" % waves_to_completed
	%RewardTexture.texture = texture_reward
	%RewardLabel.text = "%s" % gold_amount
	texture_normal = map_texture_normal
	texture_hover = map_texture_hover
	texture_pressed = map_texture_clicked

func _launch_game():
	%ClickPlayer.play()
	$/root/Game/TransitionLayer.close_transition()
	get_tree().paused = false
	
func _on_transition_layer_transition_is_finished(_anim_name):
	if has_been_pressed :
		pass
		get_tree().reload_current_scene()

func _on_pressed():
	print("Button Pressed !")
	Global.selected_map = map_of_quest_index
	Global.selected_difficulty = difficulty
	Global.sequences = enemy_sequence
	Global.gold_reward = gold_amount
	Global.starting_wave = 0
	has_been_pressed = true
	_launch_game()
