class_name ChallengeManager
extends CanvasLayer

@export var number_of_map = 5
static var is_open = false

func _ready():
	var index = 1
	for map in Global.map_challenge_score:
		var button = preload("res://GameElements/Screens/challenge/challenge_map_button.tscn").instantiate()
		if index <= 5:
			button.texture_normal = load("res://Assets/UI/challenge_selection/map_1_%s.png" % index)
			button.texture_hover = load("res://Assets/UI/challenge_selection/map_1_%s_hover.png" % index)
			button.texture_focused = load("res://Assets/UI/challenge_selection/map_1_%s_focus.png" % index)
		else:
			button.texture_normal = load("res://Assets/UI/map_selection_button/map_0.png")
			button.texture_hover = load("res://Assets/UI/map_selection_button/map_0_clicked.png")
			button.texture_focused = load("res://Assets/UI/map_selection_button/map_0_hover.png")
		button.text = "Max Score : \n %s" % Global.map_challenge_score[map]
		button.challenge_button_pressed.connect(show_skill_selection)
		button.index = index
		index += 1
		%MapList.add_child(button)
	
func show_skill_selection():
	%SkillSelection.show_skill_selection()

func show_challenge():
	get_tree().paused = true
	%AnimationPlayer.play("show_challenge")
	is_open = true
	if Global.player_using_controller:
		await %AnimationPlayer.animation_finished
		%MapList.get_child(0).grab_focus()
	
func hide_challenge():
	is_open = false
	get_tree().paused = false
	%AnimationPlayer.play("hide_challenge")


func _on_back_button_pressed():
	hide_challenge()
