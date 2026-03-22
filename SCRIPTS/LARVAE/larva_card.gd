extends Node2D

var grabbed := false
var original_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grabbed:
		global_position = get_viewport().get_mouse_position()

func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouse and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			grabbed = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		if event.button_index == MOUSE_BUTTON_LEFT:
			grabbed = false
			global_position = original_position
