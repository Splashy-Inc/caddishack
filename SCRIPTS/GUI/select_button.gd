extends Button

class_name SelectButton

@export var select_target : Variant

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_select_target(new_select_target):
	select_target = new_select_target

func get_select_target() -> Variant:
	return select_target
