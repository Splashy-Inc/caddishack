extends Node2D

class_name Terrarium

@export var info : TerrariumInfo

@onready var material_layer: TileMapLayer = $MaterialLayer

@onready var materials_container: Node = $Materials
@onready var beads_container: Node = $Beads
@onready var larvae_container: Node = $Larvae

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_materials()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_material(material_info: MaterialInfo):
	var new_material := Globals.generate_material(material_info)
	materials_container.add_child(new_material)
	if material_info.cell == Vector2i.ZERO:
		new_material.global_position = get_spawnable_material_cell_center()
		material_info.cell = get_material_cell_at(new_material.global_position)
	else:
		new_material.global_position = get_material_cell_center(material_info.cell)

	
	Globals.run_info.terrarium = get_terrarium_state()

func generate_materials():
	await clear_playing_field()
	
	for material_info in info.materials:
		spawn_material(material_info)

func clear_playing_field():
	for material in get_materials():
		material.get_parent().remove_child(material)
		material.queue_free()
	
	for bead in beads_container.get_children():
		beads_container.remove_child(bead)
		bead.queue_free()

func get_materials() -> Array[BeadMaterial]:
	var materials: Array[BeadMaterial]
	for material in materials_container.get_children():
		materials.append(material)
	return materials

func get_terrarium_state() -> TerrariumInfo:
	var new_info := TerrariumInfo.new()
	for material in get_materials():
		new_info.materials.append(material.info)
	return new_info

func get_material_cells() -> Array[Vector2i]:
	return material_layer.get_used_cells()
	
func get_spawnable_material_cell_center() -> Vector2:
	return to_global(material_layer.map_to_local(get_material_cells().pick_random()))

func get_material_cell_at(global_pos: Vector2):
	return material_layer.local_to_map(material_layer.to_local(global_pos))

func get_material_cell_center(material_cell: Vector2i):
	return to_global(material_layer.map_to_local(material_cell))
