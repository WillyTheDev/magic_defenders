extends TextureButton

var  text = ""
var index = 0
var has_been_pressed
signal challenge_button_pressed

func _ready():
	%Label.text = text

func _on_pressed():
	print("Button Pressed !")
	$/root/Game/TransitionLayer.transition_is_finished.connect(_on_transition_layer_transition_is_finished)
	Global.is_urgent_quest = false
	Global.selected_map = index
	Global.selected_difficulty = 99
	Global.sequences = []
	Global.gold_reward = 0
	Global.starting_wave = 0
	has_been_pressed = true
	challenge_button_pressed.emit()

func _on_transition_layer_transition_is_finished(_anim_name):
	if has_been_pressed && is_inside_tree():
		
		get_tree().reload_current_scene()
