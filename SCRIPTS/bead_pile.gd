extends BeadContainer

class_name BeadPile

@export var info : BeadPileInfo

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

func position_bead(bead: Bead):
	if bead_container_shape.shape is CircleShape2D:
		var placement_radius = bead_container_shape.shape.radius
		bead.position = Vector2(1000, 1000)
		bead.rotation = randf_range(0.0, PI*2)
		while bead.global_position.distance_to(bead_container.global_position) > placement_radius:
			bead.position = Vector2(randi_range(-placement_radius, placement_radius), randi_range(-placement_radius, placement_radius))

func draw_bead() -> Bead:
	var bead = bead_container.get_children().pick_random()
	return bead
