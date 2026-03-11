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
@onready var larvae_container: Node = $PlayingField/Larvae
@onready var larva_camera: Camera2D = $PlayingField/LarvaCamera
@onready var station_ui: StationUI = $StationUI

func _station_ready():
	await generate_materials()
	hatch_next_egg()

func _on_larva_died(larva: CaddisFly):
	larva.bead.reparent(beads_container)
	hatch_next_egg()

func hatch_next_egg():
	if eggs_container.get_child_count() > 0:
		var next_egg = eggs_container.get_children().pick_random() as EggMaterial
		next_egg.hatched.connect(_on_egg_hatched)
		var new_larva = next_egg.spawn_larva()
		if materials_container.get_children().is_empty():
			new_larva.bead_speed_mod = 15.0
			station_ui.materials_out_label.show()
	else:
		eggs_depleted.emit()

func _on_egg_hatched(new_larva: CaddisFly, spawn_point: Vector2):
	if is_instance_valid(new_larva):
		larvae_container.add_child(new_larva)
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
	
	Globals.run_info.terrarium = get_terrarium_state()
	won.emit(self)

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
	
	for larva in larvae_container.get_children():
		larvae_container.remove_child(larva)
		larva.queue_free()

func load_run_info():
	info = Globals.run_info.terrarium
	await generate_materials()
	hatch_next_egg()

func get_materials() -> Array[BeadMaterial]:
	var materials: Array[BeadMaterial]
	for material in materials_container.get_children():
		materials.append(material)
	
	for egg in eggs_container.get_children():
		materials.append(egg)
	
	return materials

func get_terrarium_state() -> TerrariumInfo:
	var new_info := TerrariumInfo.new()
	for material in get_materials():
		new_info.materials.append(material.info)
	
	return new_info
