extends Node2D

class_name BeadPile

@export var info : BeadPileInfo
@export var bead_scene : PackedScene

@onready var bead_container: Node2D = $Beads
@onready var bead_container_shape: CollisionShape2D = $Beads/CollisionShape2D

func _ready() -> void:
	generate_beads()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_pile_stats() -> Dictionary:
	return info.get_pile_stats()

func generate_beads():
	for bead_info in info.get_beads():
		var new_bead = bead_scene.instantiate()
		new_bead.initialize(bead_info)
		add_bead(new_bead)

func add_bead(new_bead: Bead):
	if new_bead in bead_container.get_children():
		print("Bead already in pile!", new_bead, " ", self)
		return
	bead_container.add_child(new_bead)
	if bead_container_shape.shape is CircleShape2D:
		new_bead.position = Vector2(1000, 1000)
		while new_bead.global_position.distance_to(bead_container.global_position) > bead_container_shape.shape.radius:
			new_bead.position = Vector2(randi_range(0, bead_container_shape.shape.radius), randi_range(0, bead_container_shape.shape.radius))

func draw_bead() -> Bead:
	var bead = bead_container.get_children().pick_random()
	return bead
