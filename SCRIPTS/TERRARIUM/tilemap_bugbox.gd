extends Node2D

class_name TerrariumBackground

@onready var spawnable_layer: TileMapLayer = $SpawnableLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_spawnable_cell_center() -> Vector2:
	return to_global(spawnable_layer.map_to_local(spawnable_layer.get_used_cells().pick_random()))
