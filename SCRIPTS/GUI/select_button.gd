extends UIButton

class_name SelectButton

@export var select_target : Variant

func set_select_target(new_select_target):
	select_target = new_select_target

func get_select_target() -> Variant:
	return select_target
