extends Node2D

@export var SPEED = 400
@export var mana_value = 1

var player = null

func _physics_process(delta):
	if player != null:
		var direction = (global_position - player.global_position).normalized() * -1
		position += direction * SPEED * delta


func _on_mana_body_body_entered(body:Player):
	body.update_mana_amount(mana_value)
	queue_free()
	


func _on_attract_zone_body_entered(body:Player):
	player = body
