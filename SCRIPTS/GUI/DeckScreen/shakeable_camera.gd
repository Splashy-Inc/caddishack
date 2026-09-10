extends Camera2D

class_name ShakeableCamera

@export var max_shake_px := 30.0
@export var shake_fade_time := 5.0

var shake_strength := 0.0

func shake():
	shake_strength = max_shake_px

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade_time * delta)
		
		offset = getRandomOffset()

func getRandomOffset() -> Vector2:
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
