class_name CardsManager
extends CanvasLayer

@export var nb_of_cards = 10
var playerCanSelectCards : bool = false

var cards : Array[Card] = [
	Card.new(
		"res://Assets/Cards/card_1%s.png",
		false,
		func():
			Defense.total_health += 10
			#This part will be applied for each already in game Defense
			apply_defense_modification(
				func(defense : Defense):
					defense.total_health += Defense.total_health,
			),
		),
	Card.new(
		"res://Assets/Cards/card_2%s.png",
		false,
		func():
			Turret.fire_rate -= 0.15
			#This part will be applied for each already in game Turret
			apply_turret_modification(
				func(turret : Turret):
					turret.get_node("TimerShoot").wait_time = Turret.fire_rate,
			),
		),
	Card.new(
		"res://Assets/Cards/card_3%s.png",
		false,
		func():
			Turret.damage += 0.5
			#This part will be applied for each already in game Turret
			apply_turret_modification(
				func(turret : Turret):
					turret.damage = Turret.damage
			),
		),
	Card.new(
		"res://Assets/Cards/card_4%s.png",
		false,
		func():
			apply_player_modification(
				func(player : Player):
					player.player_damage += 1,
				),
		),
	Card.new(
		"res://Assets/Cards/card_5%s.png",
		false,
		func():
			apply_player_modification(
				func(player : Player):
					player.player_speed *= 1.3,
				),
		),
	Card.new(
		"res://Assets/Cards/card_6%s.png",
		false,
		func():
			#This part will be applied for each already in game Defense
			apply_defense_modification(
				func(defense : Defense):
					defense.modulate = "ffffff"
					defense.current_health = defense.total_health,
				),
		),
	Card.new(
		"res://Assets/Cards/card_7%s.png",
		false,
		func():
			Turret.turret_shoot_area += 0.25
			#This part will be applied for each already in game Turret
			apply_turret_modification(
				func(turret : Turret):
					var shootZone : Area2D = turret.get_node("ShootZone")
					shootZone.scale.x = Turret.turret_shoot_area
					shootZone.scale.y = Turret.turret_shoot_area,
				),
		),
	Card.new(
		"res://Assets/Cards/card_8%s.png",
		true,
		func():
			MagicBolt.has_auto_target_on = true
			MagicBolt.range = 1000
			MagicBolt.texture = load("res://Assets/Player/water_bolt.png"),
		),
	Card.new(
		"res://Assets/Cards/card_9%s.png",
		true,
		func():
			MagicBolt.is_reducing_speed = true
			MagicBolt.texture = load("res://Assets/Player/frost_bolt.png"),
		),
	Card.new(
		"res://Assets/Cards/card_10%s.png",
		true,
		func():
			MagicBolt.is_passing_through = true
			MagicBolt.texture = load("res://Assets/Player/bouncing_bolt.png"),
		),
]


var card_1 = 0
var card_2 = 0
var card_3 = 0

var player_has_drawn_unique = false

func choose_cards_to_show():
	print(nb_of_cards)
	# Draw a random card between 1 and nb_of_cards randi() % nb_of_cards
	card_1 = cards[randi() % nb_of_cards]
	card_2 = cards[randi() % nb_of_cards]
	card_3 = cards[8]
	card_1 = check_if_unique(card_1)
	card_2 = check_if_unique(card_2)
	card_3 = check_if_unique(card_3)
	
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
	get_tree().paused = true
	playerCanSelectCards = true
	%CardTimer.start()
	%CardsManagerAnimationPlayer.play("show_cards")
	visible = true
	
func hide_cards():
	get_tree().paused = false
	playerCanSelectCards = false
	visible = false

#This will insure that the drawn cards aren't unique if player already drawn a unique card
func check_if_unique(card:Card):
	if card.is_unique && player_has_drawn_unique:
		return check_if_unique(cards[randi() % nb_of_cards])
	else:
		return card

func check_player_choice_is_unique(card : Card):
	if card.is_unique :
		player_has_drawn_unique = true


func _on_choice_1_pressed():
	if playerCanSelectCards:
		check_player_choice_is_unique(card_1)
		card_1.apply_effect()
		hide_cards()


func _on_choice_2_pressed():
	if playerCanSelectCards:
		check_player_choice_is_unique(card_2)
		card_2.apply_effect()
		hide_cards()


func _on_choice_3_pressed():
	if playerCanSelectCards:
		check_player_choice_is_unique(card_3)
		card_3.apply_effect()
		hide_cards()

func _on_card_timer_timeout():
	playerCanSelectCards = true
	
func _on_player_show_cards():
	choose_cards_to_show()



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


