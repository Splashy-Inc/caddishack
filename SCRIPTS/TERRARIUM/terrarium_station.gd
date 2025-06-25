extends Station

class_name TerrariumStation

signal eggs_depleted

@export var info : TerrariumInfo
@export var material_scene : PackedScene

@onready var container_layer: TerrariumBackground = $PlayingField/ContainerLayer
@onready var playing_field: Node2D = $PlayingField
@onready var materials_container: Node = $PlayingField/Materials
@onready var beads_container: Node = $PlayingField/Beads
@onready var eggs_container: Node = $PlayingField/Eggs
@onready var larva_camera: Camera2D = $PlayingField/LarvaCamera

func _station_ready():
	for material_info in info.materials:
		var new_material := Globals.generate_material(material_info)
		if new_material is EggMaterial:
			eggs_container.add_child(new_material)
			new_material.global_position = container_layer.get_spawnable_egg_cell_center()
		else:
			materials_container.add_child(new_material)
			new_material.global_position = container_layer.get_spawnable_material_cell_center()
		material_info.global_positon = new_material.global_position
	hatch_next_egg()
	Globals.run_info.terrarium = info

func _on_larva_died(larva: CaddisFly):
	larva.bead.reparent(beads_container)
	hatch_next_egg()

func hatch_next_egg():
	if eggs_container.get_child_count() > 0:
		var next_egg = eggs_container.get_children().pick_random() as EggMaterial
		next_egg.hatched.connect(_on_egg_hatched)
		next_egg.spawn_larva()
	else:
		eggs_depleted.emit()

func _on_egg_hatched(new_larva: CaddisFly, spawn_point: Vector2):
	if is_instance_valid(new_larva):
		playing_field.add_child(new_larva)
		new_larva.died.connect(_on_larva_died)
		new_larva.global_position = spawn_point
		larva_camera.larva = new_larva
