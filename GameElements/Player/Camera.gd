extends Camera2D


@export var shakeFade : float = 5.0

var rnd = RandomNumberGenerator.new()
var speed = 500
var shake_strength: float = 0
var move_camera_toward_core = false
var initial_position : Vector2 = Vector2(0,0)
var target : Vector2 = Vector2(0,0)

func _ready():
	$/root/Game/Map/Core.core_destroyed.connect(move_toward_core)
	
func move_toward_core(core_position):
	print("Camera moving toward Core ! : %s" % core_position)
	target = core_position
	initial_position = global_position
	print(target)
	move_camera_toward_core = true

func apply_shake(strength):
	shake_strength = strength

func random_offset() -> Vector2:
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	
func _process(delta):
	if move_camera_toward_core:
		global_position = global_position.lerp(target, delta * 4)
	else:
		var mouse_offset = get_viewport().get_mouse_position() - Vector2(get_viewport().size / 2)
		position = lerp(Vector2(), mouse_offset.normalized() * 300, mouse_offset.length() / 1000)
		if shake_strength > 0:
			shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
			offset = random_offset()
