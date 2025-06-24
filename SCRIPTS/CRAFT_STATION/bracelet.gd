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
