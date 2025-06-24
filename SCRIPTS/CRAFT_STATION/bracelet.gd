extends BeadSet

class_name Bracelet

@export var info : BraceletInfo

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
		match bead.info.special:
			Globals.MaterialType.BASIC:
				info.update_points(1)
				info.update_mult(check_chain(cur_special_chain, null, "special"))
			_:
				info.update_points(3)
				info.update_mult(check_chain(cur_special_chain, bead, "special"))
		
		if bead.info.color != Globals.MaterialColor.COLORLESS:
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
				bead_info = bead.info.color
				chain_info = chain.back().info.color
			"special":
				bead_info = bead.info.special
				chain_info = chain.back().info.special
		if chain_info == bead_info:
			chain.append(bead)
			return 0
	
	var mult
	if chain.size() >= 5:
		mult = 4
	elif chain.size() >= 3:
		mult = 2
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
