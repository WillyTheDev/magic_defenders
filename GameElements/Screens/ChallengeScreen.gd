extends CanvasLayer

@export var number_of_map = 5

func _ready():
	var index = 1
	for map in Global.map_challenge_score:
		var button = preload("res://GameElements/Screens/challenge/challenge_map_button.tscn").instantiate()
		button.texture_normal = load("res://Assets/UI/challenge_selection/map_1_%s.png" % index)
		button.texture_hover = load("res://Assets/UI/challenge_selection/map_1_%s_hover.png" % index)
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
	
func hide_challenge():
	get_tree().paused = false
	%AnimationPlayer.play("hide_challenge")


func _on_back_button_pressed():
	hide_challenge()
