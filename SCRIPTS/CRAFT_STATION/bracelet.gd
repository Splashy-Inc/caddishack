extends BeadSet

class_name Bracelet

@export var info : BraceletInfo

const BASIC_POINTS = 1
const SPECIAL_POINTS = 3
const THREE_CHAIN_MULT = 2
const FIVE_CHAIN_MULT = 4

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
	info.color_chains.clear()
	info.special_chains.clear()
	info.update_points(0, true)
	info.update_mult(1, true)
	
	var cur_color_chain: Array[Bead]
	var cur_special_chain: Array[Bead]
	for bead in get_beads():
		# Add points to tally
		match bead.info.special.type:
			SpecialMaterialInfo.SpecialType.BASIC:
				info.update_points(BASIC_POINTS)
				info.update_mult(check_chain(cur_special_chain, null, "special"))
			_:
				info.update_points(SPECIAL_POINTS)
				info.update_mult(check_chain(cur_special_chain, bead, "special"))
		
		if bead.info.sand.color != SandMaterialInfo.SandColor.COLORLESS:
			info.update_mult(check_chain(cur_color_chain, bead, "color"))
		else:
			check_chain(cur_color_chain, null, "color")
	
	info.update_mult(check_chain(cur_color_chain, null, "color"))
	info.update_mult(check_chain(cur_special_chain, null, "special"))
	return info.get_value()

func check_chain(chain: Array[Bead], bead: Bead, type: String):
	if bead:
		# Nothing to check if chain is empty
		if chain.is_empty():
			chain.append(bead)
			return 0
	
		# If chain has something in it, check if bead matches chain
		var bead_info
		var chain_info
		match type:
			"color":
				bead_info = bead.info.sand.color
				chain_info = chain.back().info.sand.color
			"special":
				bead_info = bead.info.special.type
				chain_info = chain.back().info.special.type
		if chain_info == bead_info:
			chain.append(bead)
			return 0
	
	var mult
	if chain.size() >= 5:
		mult = FIVE_CHAIN_MULT
	elif chain.size() >= 3:
		mult = THREE_CHAIN_MULT
	else:
		mult = 0
	
	if mult > 0:
		match type:
			"color":
				if not chain in info.color_chains:
					info.color_chains.append(chain.duplicate())
			"special":
				if not chain in info.special_chains:
					info.special_chains.append(chain.duplicate())
	
	chain.clear()
	if bead:
		chain.append(bead)
	
	return mult

func is_complete() -> bool:
	return get_beads().size() >= bead_slots.size()

func travel_to(target_global_position: Vector2, target_scale: Vector2 = Vector2(1.0,1.0), target_rotation: float = 0.0):
	travel_target_global_position = target_global_position
	scale = target_scale
	travel_target_rotation = target_rotation
	is_travelling = true
