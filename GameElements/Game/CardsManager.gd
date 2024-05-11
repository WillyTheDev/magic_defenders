class_name CardsManager
extends CanvasLayer

@export var nb_of_cards = 7
var playerCanSelectCards : bool = false

var cards : Array[Card] = [
	Card.new(
		"res://Assets/Cards/card_1%s.png",
		func():
			apply_defense_modification(
				func(defense : Defense):
					defense.total_health += 5
			),
		),
	Card.new(
		"res://Assets/Cards/card_2%s.png",
		func():
			apply_turret_modification(
				func(turret : Turret):
					turret.fire_rate -= 0.15
					turret.get_node("TimerShoot").wait_time = turret.fire_rate,
			),
		),
	Card.new(
		"res://Assets/Cards/card_3%s.png",
		func():
			apply_turret_modification(
				func(turret : Turret):
					turret.damage += 1,
			),
		),
	Card.new(
		"res://Assets/Cards/card_4%s.png",
		func():
			apply_player_modification(
				func(player : Player):
					player.player_damage *= 1.2,
				),
		),
	Card.new(
		"res://Assets/Cards/card_5%s.png",
		func():
			apply_player_modification(
				func(player : Player):
					player.player_speed *= 1.2,
				),
		),
	Card.new(
		"res://Assets/Cards/card_6%s.png",
		func():
			apply_enemy_modification(
				func(enemy: Enemy):
					enemy.speed *= 0.8,
				),
		),
	Card.new(
		"res://Assets/Cards/card_7%s.png",
		func():
			apply_enemy_modification(
				func(enemy : Enemy):
					enemy.health *= 0.8,
				),
		),
	Card.new(
		"res://Assets/Cards/card_8%s.png",
		func():
			apply_defense_modification(
				func(defense : Defense):
					defense.modulate = "ffffff"
					defense.current_health = defense.total_health,
				),
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
	%CardTimer.start()
	visible = true
	
func hide_cards():
	playerCanSelectCards = false
	visible = false

func _on_game_should_show_cards():
	choose_cards_to_show()
	

func _on_choice_1_pressed():
	if playerCanSelectCards:
		card_1.apply_effect()
		hide_cards()


func _on_choice_2_pressed():
	if playerCanSelectCards:
		card_2.apply_effect()
		hide_cards()


func _on_choice_3_pressed():
	if playerCanSelectCards:
		card_3.apply_effect()
		hide_cards()

func _on_card_timer_timeout():
	playerCanSelectCards = true

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
