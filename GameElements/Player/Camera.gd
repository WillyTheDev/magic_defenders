extends Camera2D


@export var shakeFade : float = 5.0

var rnd = RandomNumberGenerator.new()

var shake_strength: float = 0

func apply_shake(strength):
	shake_strength = strength

func random_offset() -> Vector2:
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	
func _process(delta):
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
	
	offset = random_offset()
