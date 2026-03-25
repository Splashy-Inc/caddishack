extends Node2D

class_name Terrarium

signal larvae_started
signal larvae_done
signal bead_limit_reached

@export var info : TerrariumInfo
@export var larvae_limit := 5
@export var bead_limit := 10
@export var start_larvae_on_drop := false

@onready var material_layer: TileMapLayer = $MaterialLayer

@onready var materials_container: Node = $Materials
@onready var beads_container: Node = $Beads
@onready var larvae_container: Node = $Larvae
@onready var simulation_timer: Timer = $SimulationTimer

var larvae_running := false

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

func add_larva(new_larva: Larva) -> bool:
	if not larvae_running and larvae_container.get_children().size() < larvae_limit:
		if is_instance_valid(new_larva.get_parent()):
			new_larva.reparent(larvae_container, true)
		else:
			larvae_container.add_child(new_larva)
		
		new_larva.died.connect(_on_larva_died)
		
		if start_larvae_on_drop:
			new_larva.process_mode = Node.PROCESS_MODE_INHERIT
		
		return true
	return false

func _on_larva_died(larva: Larva):
	add_bead(larva.bead)
	larvae_container.remove_child(larva)
	
	if larvae_container.get_children().size() == 0:
		larvae_done.emit()
		larvae_running = false

func start_larvae(round_length: float = 0.0) -> bool:
	if larvae_container.get_child_count() >= larvae_limit:
		for node in larvae_container.get_children():
			if node is Larva:
				larvae_running = true
				node.process_mode = Node.PROCESS_MODE_INHERIT
		
		if larvae_running:
			if round_length > 0:
				simulation_timer.start(round_length)
			larvae_started.emit()
			return true
	
	return false

func add_bead(new_bead: Bead) -> bool:
	if get_beads().size() < bead_limit:
		if is_instance_valid(new_bead.get_parent()):
			new_bead.reparent(beads_container, true)
		else:
			beads_container.add_child(new_bead)
	
		if get_beads().size() == bead_limit:
			bead_limit_reached.emit()
		
		return true
	else:
		return false

func remove_bead(bead: Bead) -> Bead:
	if bead in get_beads():
		beads_container.remove_child(bead)
		return bead
	else:
		return null

func get_beads() -> Array[Bead]:
	var beads : Array[Bead]
	
	for node in beads_container.get_children():
		if node is Bead:
			beads.append(node)
	
	return beads

func _on_simulation_timer_timeout() -> void:
	for node in larvae_container.get_children():
		if node is Larva:
			node._on_bead_completed()
