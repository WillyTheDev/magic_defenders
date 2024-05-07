class_name Bat
extends Enemy

var target = null

func _ready():
	play_animation_idle()
	target = get_parent().get_node("Core")

func _physics_process(delta):
	if target != null:
		var direction = (global_position - target.global_position).normalized() * -1
		position += delta * speed * direction

func take_damage(damage):
	play_animation_hit()
	health -= damage
	if health <= 0:
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		new_smoke.global_position = global_position
		get_parent().add_child(new_smoke)
		var mana_to_spawn = floor(randf() * MANA_AMOUNT + 1)
		for mana in mana_to_spawn:
			const MANA = preload("res://GameElements/misc/mana.tscn")
			var new_mana = MANA.instantiate()
			new_mana.rotation = rotation
			new_mana.global_position = global_position
			get_parent().call_deferred("add_child", new_mana)
		queue_free()
