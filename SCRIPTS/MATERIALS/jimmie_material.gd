extends BeadMaterial

class_name JimmieMaterial

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D6

# Called when the node enters the scene tree for the first time.
func _material_ready() -> void:
	if not info is SpecialMaterialInfo:
		info = SpecialMaterialInfo.new()
	
	info.type = SpecialMaterialInfo.SpecialType.JIMMIE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func disable():
	if not is_node_ready():
		await ready
	remove_from_group("materials")
	collision_polygon_2d.disabled = true
