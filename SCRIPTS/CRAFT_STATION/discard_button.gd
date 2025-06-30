extends Button

class_name DiscardButton

@export var remaining := 2

@onready var number: Label = $HBoxContainer/Number

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	number.text = str(remaining)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use_discard():
	if remaining > 0:
		remaining -= 1
		number.text = str(remaining)
	
	if remaining <= 0:
		disabled = true
