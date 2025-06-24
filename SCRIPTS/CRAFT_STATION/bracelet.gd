extends BeadSet

class_name Bracelet

func position_bead(bead: Bead):
	bead.travel_to(bead.get_parent().global_position)

func get_open_slot_count():
	var num_open_slots = 0
	for slot in bead_slots:
		if slot.get_child_count() == 0:
			num_open_slots += 1
	return num_open_slots

func calculate_value() -> int:
	var points = 0
	var mult = 0
	
	var cur_color_chain: Array[Bead]
	var cur_special_chain: Array[Bead]
	for bead in get_beads():
		# Add points to tally
		match bead.info.special:
			Globals.MaterialType.BASIC:
				points += 1
				check_chain(cur_special_chain, null, "special")
			_:
				points += 3
				mult += check_chain(cur_special_chain, bead, "special")
		
		if bead.info.color != Globals.MaterialColor.COLORLESS:
			mult += check_chain(cur_color_chain, bead, "color")
		else:
			check_chain(cur_color_chain, null, "color")
	
	mult += check_chain(cur_color_chain, null, "color")
	mult += check_chain(cur_special_chain, null, "special")
	return points * mult

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
		print("5+ " + type + " chain: ", chain)
		mult = 4
	elif chain.size() >= 3:
		print("3+ " + type + " chain: ", chain)
		mult = 2
	else:
		mult = 0
	chain.clear()
	if bead:
		chain.append(bead)
	return mult

func is_complete() -> bool:
	return get_beads().size() >= bead_slots.size()
