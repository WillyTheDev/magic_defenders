extends Node2D

var value = 10

func set_value(damage_value):
	%Label.text = "%s" % damage_value

func _ready():
	%Label.rotation_degrees += randi() % 60
	%AnimationPlayer.play("appears")
	%Timer.start()

func _on_timer_timeout():
	queue_free()
