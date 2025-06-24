extends BeadContainer

class_name BeadPile

func _ready() -> void:
	generate_beads()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_pile_stats() -> Dictionary:
	return bead_array_info.get_pile_stats()

func position_bead(bead: Bead):
	if bead_container_shape.shape is CircleShape2D:
		var placement_radius = bead_container_shape.shape.radius
		var global_pile_placement_position = to_global(Vector2(randi_range(-placement_radius, placement_radius), randi_range(-placement_radius, placement_radius)))
		bead.rotation = randf_range(0.0, PI*2)
		bead.travel_to(global_pile_placement_position, bead.scale, randf_range(0.0, PI*2))
