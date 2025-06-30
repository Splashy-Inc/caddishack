extends HBoxContainer

class_name ItemInfoRow

@export var label: Label
@export var value: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = ""
	value.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_label(text: String):
	if not is_node_ready():
		await ready
	label.text = text
	
func set_value(text: String):
	if not is_node_ready():
		await ready
	value.text = text
