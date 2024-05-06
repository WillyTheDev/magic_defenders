extends Node2D

@export var SPEED = 400
var player = null

func _physics_process(delta):
	if player != null:
		var direction = (global_position - player.global_position).normalized() * -1
		position += direction * SPEED * delta


func _on_mana_body_body_entered(body):
	queue_free()


func _on_attract_zone_body_entered(body):
	player = body
