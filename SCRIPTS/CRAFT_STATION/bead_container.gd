extends Node2D

class_name BeadContainer

@export var bead_scene := preload("res://SCENES/TERRARIUM/bead.tscn")
@export var bead_array_info : BeadArrayInfo

@export var bead_container: Node2D
@export var bead_container_shape: CollisionShape2D

func _ready() -> void:
	_container_ready()

func _container_ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_container_process(delta)

func _container_process(delta: float):
	pass

func generate_beads():
	for bead_info in bead_array_info.get_beads():
		var new_bead = bead_scene.instantiate()
		new_bead.initialize(bead_info)
		add_bead(new_bead)

func add_bead(new_bead: Bead) -> bool:
	if is_bead_in_container(new_bead):
		print("Bead already in container!", new_bead, " ", self)
		return false
	
	if set_bead_parent(new_bead):
		position_bead(new_bead)
		return true
	else:
		return false

func is_bead_in_container(bead: Bead):
	return bead in bead_container.get_children()

func set_bead_parent(bead: Bead) -> bool:
	if bead.get_parent():
		var old_global_transform = bead.global_transform
		bead.reparent(bead_container, false)
		bead.global_transform = old_global_transform
	else:
		bead_container.add_child(bead)
	bead.set_clickable(false)
	return true

func position_bead(bead: Bead):
	bead.travel_to(bead.get_parent().global_position, bead.global_scale, bead.rotation)

func draw_bead(bead = null) -> Bead:
	var beads = get_beads()
	if beads.is_empty():
		return null
	else:
		if not bead:
			bead = get_beads().pick_random()
	return bead

func get_beads() -> Array[Bead]:
	var cur_beads : Array[Bead]
	for child in bead_container.get_children():
		if child is Bead and not child in cur_beads:
			cur_beads.append(child)
	return cur_beads
