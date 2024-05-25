extends Node2D

@export var SPEED = 400
@export var mana_value = 1
@export var is_hat = false

var hat_index = 0
var player = null


func _physics_process(delta):
	if player != null:
		var direction = (global_position - player.global_position).normalized() * -1
		position += direction * SPEED * delta


func _on_mana_body_body_entered(body):
	if body is Player:
		if is_hat:
			body.get_new_hat(hat_index)
		else:
			body.update_mana_amount(mana_value, true)
		queue_free()
	


func _on_attract_zone_body_entered(body):
	if body is Player:
		player = body
