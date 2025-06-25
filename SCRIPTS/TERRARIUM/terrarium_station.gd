extends Station

class_name TerrariumStation

@export var info : TerrariumInfo
@export var material_scene : PackedScene

@onready var container_layer: TerrariumBackground = $PlayingField/ContainerLayer
@onready var playing_field: Node2D = $PlayingField
@onready var materials_container: Node2D = $PlayingField/Materials

func _station_ready():
	for material in info.materials:
		var new_material = material_scene.instantiate() as BeadMaterial
		new_material.info = material
		new_material.set_body()
		materials_container.add_child(new_material)
		new_material.global_position = container_layer.get_spawnable_cell_center()
		material.global_positon = new_material.global_position
	Globals.run_info.terrarium = info
