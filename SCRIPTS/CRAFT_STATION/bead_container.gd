extends Node2D

class_name BeadContainer

@export var bead_scene : PackedScene

@onready var bead_container: Node2D = $Beads/Container
@onready var bead_container_shape: CollisionShape2D = $Beads/CollisionShape2D

func _ready() -> void:
	_container_ready()

func _container_ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_container_process(delta)

func _container_process(delta: float):
	pass

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
		bead.reparent(bead_container)
	else:
		bead_container.add_child(bead)
	return true

func position_bead(bead: Bead):
	bead.position = Vector2.ZERO

func draw_bead() -> Bead:
	var bead = bead_container.get_children().pick_random()
	return bead
