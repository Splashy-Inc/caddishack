extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_down() -> void:
	var event = InputEventAction.new()
	event.action = "speed_up"
	event.pressed = true
	Input.parse_input_event(event)

func _on_button_up() -> void:
	var event = InputEventAction.new()
	event.action = "speed_up"
	event.pressed = false
	Input.parse_input_event(event)
