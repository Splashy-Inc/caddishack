extends Node2D

class_name TerrariumBackground

@onready var material_layer: TileMapLayer = $MaterialLayer
@onready var egg_layer: TileMapLayer = $EggLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_spawnable_material_cell_center() -> Vector2:
	return to_global(material_layer.map_to_local(material_layer.get_used_cells().pick_random()))

func get_spawnable_egg_cell_center() -> Vector2:
	return to_global(egg_layer.map_to_local(egg_layer.get_used_cells().pick_random()))

func get_material_cell_at(global_pos: Vector2):
	return material_layer.local_to_map(material_layer.to_local(global_pos))

func get_material_cell_center(material_cell: Vector2i):
	return to_global(material_layer.map_to_local(material_cell))
