extends BeadSet

class_name Bracelet

signal animated_value_calculated(value: int)

@export var info : BraceletInfo
@onready var scoring_sound: AudioStreamPlayer = $ScoringSound

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
	bead_slots = get_bead_slots()
	set_beads(info.get_bead_array_info())

func position_bead(bead: Bead):
	bead.travel_to(bead.get_parent().global_position)

func get_open_slot_count():
	var num_open_slots = 0
	for slot in bead_slots:
		if not slot.has_bead():
			num_open_slots += 1
	return num_open_slots

func calculate_value() -> int:
	return info.calculate_value()

func calculate_value_animated():
	for slot in bead_slots:
		await slot.calculate_value_animated(info.get_bead_array_info(), scoring_sound)
		scoring_sound.pitch_scale += .025
	scoring_sound.pitch_scale = .5
	animated_value_calculated.emit(info.calculate_value())

func is_complete() -> bool:
	return get_beads().size() >= bead_slots.size()

func travel_to(target_global_position: Vector2, target_scale: Vector2 = Vector2(1.0,1.0), target_rotation: float = 0.0):
	travel_target_global_position = target_global_position
	scale = target_scale
	travel_target_rotation = target_rotation
	is_travelling = true
