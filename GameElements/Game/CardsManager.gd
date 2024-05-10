class_name CardsManager
extends CanvasLayer


func choose_cards_to_show():
	assert("Select_the_cards_to_Show")

func assign_textures_to_choice(choice_button_index: int, cards_index: int):
	assert("Assigning textures to button choice")

func show_cards():
	visible = true

func _on_game_should_show_cards():
	choose_cards_to_show()
	
