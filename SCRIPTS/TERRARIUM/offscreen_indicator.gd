extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	position = Vector2(clamp(position.x, 0 + (16 * scale.x), viewport_size.x - (16 * scale.x)), clamp(position.y, 0 + (16 * scale.y), viewport_size.y - (16 * scale.y)))
