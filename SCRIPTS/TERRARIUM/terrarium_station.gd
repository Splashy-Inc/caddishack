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
	await generate_materials()
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

func spawn_material(material_info: MaterialInfo):		
	var new_material := Globals.generate_material(material_info)
	if new_material is EggMaterial:
		eggs_container.add_child(new_material)
		new_material.global_position = container_layer.get_spawnable_egg_cell_center()
	else:
		materials_container.add_child(new_material)
		if material_info.cell == Vector2i.ZERO:
			new_material.global_position = container_layer.get_spawnable_material_cell_center()
			material_info.cell = container_layer.get_material_cell_at(new_material.global_position)
		else:
			new_material.global_position = container_layer.get_material_cell_center(material_info.cell)

func _on_eggs_depleted() -> void:
	for child in beads_container.get_children():
		if child is Bead:
			Globals.run_info.bead_pile.beads.append(child.info)
	won.emit(self)

func generate_materials():
	for material in materials_container.get_children():
		material.queue_free()
	for egg in eggs_container.get_children():
		egg.queue_free()
	for bead in beads_container.get_children():
		bead.queue_free()
	for larva in get_tree().get_nodes_in_group("Larvae"):
		larva.queue_free()
		
	for material_info in info.materials:
		spawn_material(material_info)

func load_run_info():
	info = Globals.run_info.terrarium
	_station_ready()
