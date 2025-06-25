extends BeadMaterial

class_name PearlMaterial

# Called when the node enters the scene tree for the first time.
func _material_ready() -> void:
	if not info is SpecialMaterialInfo:
		info = SpecialMaterialInfo.new()
	
	info.type = SpecialMaterialInfo.SpecialType.PEARL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
