extends Resource

class_name ZoomInfo

@export var original_transform : Transform2D
@export var original_z : int
@export var zoom_transform : Transform2D
@export var zoom_z : int

func _init(new_original_transform: Transform2D, new_original_z: int) -> void:
	original_transform = new_original_transform
	original_z = new_original_z
