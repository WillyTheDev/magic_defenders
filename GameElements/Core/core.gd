extends Node2D

signal core_destroyed
signal core_attacked

var health = 10

func _on_area_2d_body_entered(body):
	if "Slime" in body.name:
		health -= 1
		core_attacked.emit()
		if health <= 0:
			destroy_core()
		
		
func destroy_core():
	core_destroyed.emit()
	const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
	var new_smoke = SMOKE.instantiate()
	new_smoke.global_position = global_position
	get_parent().add_child(new_smoke)
	queue_free()
