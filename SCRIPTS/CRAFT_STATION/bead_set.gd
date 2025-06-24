extends BeadContainer

class_name BeadSet

signal bead_clicked(bead: Bead)

var bead_slots : Array[Node2D]

func _container_ready():
	for child in bead_container.get_children():
		if child is Node2D:
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
				var old_global_transform = bead.global_transform
				bead.reparent(slot, false)
				bead.global_transform = old_global_transform
			else:
				slot.add_child(bead)
			bead.set_clickable(true)
			bead.clicked.connect(_on_bead_clicked.bind(bead))
			return true
	return false

func position_bead(bead: Bead):
	bead.travel_to(bead.get_parent().global_position, bead.global_scale, bead.rotation)

func get_beads():
	var cur_beads : Array[Bead]
	for slot in bead_slots:
		for child in slot.get_children():
			if child is Bead and not child in cur_beads:
				cur_beads.append(child)
				break
	return cur_beads

func _on_bead_clicked(bead: Bead):
	if is_bead_in_container(bead):
		bead_clicked.emit(bead)
	else:
		bead.clicked.disconnect(_on_bead_clicked)
