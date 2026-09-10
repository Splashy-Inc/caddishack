extends Node

func get_random_position_offset(max_magnitude_px: float) -> Vector2:
	return Vector2(randf_range(-max_magnitude_px, max_magnitude_px), randf_range(-max_magnitude_px, max_magnitude_px))
