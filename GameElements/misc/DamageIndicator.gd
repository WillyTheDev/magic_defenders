extends Label

var value = 10

func set_value(value):
	text = "%s" % value

func _ready():
	rotation_degrees += randi() % 60
	%AnimationPlayer.play("appears")
	%Timer.start()

func _on_timer_timeout():
	queue_free()
