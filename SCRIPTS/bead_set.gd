extends BeadContainer

class_name BeadSet

var bead_slots : Array[Node2D]

func _container_ready():
	for child in bead_container.get_children():
		if child is Node2D:
			print(child)
			bead_slots.append(child)

func is_bead_in_container(bead: Bead):
	for slot in bead_slots:
		for child in slot.get_children():
			if child == bead:
				return true
	return false

func set_bead_parent(bead: Bead) -> bool:
	for slot in bead_slots:
		if slot.get_child_count() > 0:
			continue
		else:
			if bead.get_parent():
				bead.reparent(slot)
			else:
				slot.add_child(bead)
			return true
	return false
