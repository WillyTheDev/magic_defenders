class_name CardsManager
extends CanvasLayer

@export var nb_of_cards = 7

var cards : Array[Card] = [
	Card.new(
		"res://Assets/Cards/card_1%s.png",
		func():
			TurretDefenseManager.defense_health += 5
			get_node("/root/Game/TurretDefenseManager").apply_defense_modification(),
		),
	Card.new(
		"res://Assets/Cards/card_2%s.png",
		func():
			TurretDefenseManager.turret_fire_rate -= 0.1
			get_node("/root/Game/TurretDefenseManager").apply_turret_modification(),
		),
	Card.new(
		"res://Assets/Cards/card_3%s.png",
		func():
			TurretDefenseManager.turret_damage += 1
			get_node("/root/Game/TurretDefenseManager").apply_turret_modification(),
		),
	Card.new(
		"res://Assets/Cards/card_4%s.png",
		func():
			PlayerManager.player_damage_factor += 0.3
			get_node("/root/Game/PlayerManager").apply_player_modification(),
		),
	Card.new(
		"res://Assets/Cards/card_5%s.png",
		func():
			PlayerManager.player_movement_speed_factor += 0.2
			get_node("/root/Game/PlayerManager").apply_player_modification(),
		),
	Card.new(
		"res://Assets/Cards/card_6%s.png",
		func():
			EnemyManager.speed_factor -= 0.2
			get_node("/root/Game/EnemyManager").apply_enemy_modification(),
		),
	Card.new(
		"res://Assets/Cards/card_7%s.png",
		func():
			EnemyManager.health_factor -= 0.2
			get_node("/root/Game/EnemyManager").apply_enemy_modification(),
		),
]


var card_1 = 0
var card_2 = 0
var card_3 = 0


func choose_cards_to_show():
	# Draw a random card between 1 and nb_of_cards
	card_1 = cards[randi() % nb_of_cards]
	card_2 = cards[randi() % nb_of_cards]
	card_3 = cards[randi() % nb_of_cards]
	%choice_1.texture_normal = load(card_1.img_path)
	%choice_1.texture_hover = load(card_1.img_path_hover)
	%choice_1.texture_pressed = load(card_1.img_path_clicked)
	%choice_2.texture_normal = load(card_2.img_path)
	%choice_2.texture_hover = load(card_2.img_path_hover)
	%choice_2.texture_pressed = load(card_2.img_path_clicked)
	%choice_3.texture_normal = load(card_3.img_path)
	%choice_3.texture_hover = load(card_3.img_path_hover)
	%choice_3.texture_pressed = load(card_3.img_path_clicked)
	show_cards()
	
func show_cards():
	visible = true
	
func hide_cards():
	visible = false

func _on_game_should_show_cards():
	choose_cards_to_show()
	

func _on_choice_1_pressed():
	card_1.apply_effect()
	hide_cards()


func _on_choice_2_pressed():
	card_2.apply_effect()
	hide_cards()


func _on_choice_3_pressed():
	card_3.apply_effect()
	hide_cards()

