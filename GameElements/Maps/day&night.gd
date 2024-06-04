extends CanvasModulate

const DAY_COLOR = Color("#ffffff")
const NIGHT_COLOR = Color("#000a15")
const TIME_SCALE = 0.01

@export var time = 0

func _process(delta):
	time += delta * TIME_SCALE
	color = NIGHT_COLOR.lerp(DAY_COLOR, (sin((PI/2)*cos(time))+1)/2)
