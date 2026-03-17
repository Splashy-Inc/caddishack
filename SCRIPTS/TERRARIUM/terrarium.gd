extends Node2D

class_name Terrarium

@onready var material_layer: TileMapLayer = $MaterialLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_material_cells() -> Array[Vector2i]:
	return material_layer.get_used_cells()
	
func get_spawnable_material_cell_center() -> Vector2:
	return to_global(material_layer.map_to_local(get_material_cells().pick_random()))

func get_material_cell_at(global_pos: Vector2):
	return material_layer.local_to_map(material_layer.to_local(global_pos))

func get_material_cell_center(material_cell: Vector2i):
	return to_global(material_layer.map_to_local(material_cell))
