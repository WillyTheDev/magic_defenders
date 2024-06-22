extends Node2D

@export var SPEED = 400
@export var mana_value = 1
@export var is_hat = false
@export var is_loot = false
@export var loot: Loot = null

var hat_index = 0
var player = null

func _ready():
	$/root/Game.on_game_is_over.connect(move_toward_player)
	

func move_toward_player():
	print("Mana moving toward player !")
	player = $/root/Game/Player

func _physics_process(delta):
	if player != null:
		var direction = (global_position - player.global_position).normalized() * -1
		position += direction * SPEED * delta


func _on_mana_body_body_entered(body):
	if body is Player:
		if is_hat:
			body.get_new_hat(hat_index)
		elif is_loot:
			body.add_new_loot(loot)
		else:
			body.update_mana_amount(mana_value, true)
		queue_free()
	


func _on_attract_zone_body_entered(body):
	if body is Player:
		player = body
