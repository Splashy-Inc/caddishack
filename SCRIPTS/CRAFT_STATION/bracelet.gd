extends BeadSet

class_name Bracelet

@export var info : BraceletInfo

var travel_target_global_position : Vector2
var travel_target_rotation : float
var is_travelling := false

func _process(delta: float) -> void:
	if is_travelling:
		if global_position.distance_to(travel_target_global_position) < 10:
			global_position = travel_target_global_position
			rotation = travel_target_rotation
			scale = Vector2(1.0, 1.0)
			is_travelling = false
		else:
			global_position = global_position.lerp(travel_target_global_position, .25)
			rotation = lerpf(rotation, travel_target_rotation, .25)
			scale = scale.lerp(Vector2(1.0, 1.0), .25)

func _container_ready():
	bead_array_info = info.bead_array_info
	bead_slots = get_bead_slots()
	generate_beads()

func position_bead(bead: Bead):
	bead.travel_to(bead.get_parent().global_position)
	calculate_value()

func get_open_slot_count():
	var num_open_slots = 0
	for slot in bead_slots:
		if slot.get_child_count() == 0:
			num_open_slots += 1
	return num_open_slots

func calculate_value() -> int:
	return info.calculate_value()

func is_complete() -> bool:
	return get_beads().size() >= bead_slots.size()

func travel_to(target_global_position: Vector2, target_scale: Vector2 = Vector2(1.0,1.0), target_rotation: float = 0.0):
	travel_target_global_position = target_global_position
	scale = target_scale
	travel_target_rotation = target_rotation
	is_travelling = true
