extends Station

class_name TerrariumStation

@export var info : TerrariumInfo

@export var material_scene : PackedScene

@onready var terrarium: Terrarium = $PlayScreen/PlayingField/Terrarium
@onready var playing_field: Node = $PlayScreen/PlayingField
@onready var materials_container: Node = $PlayScreen/PlayingField/Materials
@onready var beads_container: Node = $PlayScreen/PlayingField/Beads
@onready var eggs_container: Node = $PlayScreen/PlayingField/Eggs
@onready var larvae_container: Node = $PlayScreen/PlayingField/Larvae

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
		next_egg.spawn_larva()

func _on_egg_hatched(new_larva: CaddisFly, spawn_point: Vector2):
	if is_instance_valid(new_larva):
		larvae_container.add_child(new_larva)
		new_larva.died.connect(_on_larva_died)
		new_larva.global_position = spawn_point

func spawn_material(material_info: MaterialInfo):
	var new_material := Globals.generate_material(material_info)
	if new_material is EggMaterial:
		eggs_container.add_child(new_material)
		new_material.global_position = terrarium.get_spawnable_material_cell_center()
	else:
		materials_container.add_child(new_material)
		if material_info.cell == Vector2i.ZERO:
			new_material.global_position = terrarium.get_spawnable_material_cell_center()
			material_info.cell = terrarium.get_material_cell_at(new_material.global_position)
		else:
			new_material.global_position = terrarium.get_material_cell_center(material_info.cell)

	
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
