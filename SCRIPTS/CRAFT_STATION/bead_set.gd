extends BeadContainer

class_name BeadSet

signal bead_clicked(bead: Bead)

var bead_slots : Array[BeadSlot]

func _container_ready():
	bead_slots = get_bead_slots()
	generate_beads()

func is_bead_in_container(bead: Bead):
	for slot in bead_slots:
		if slot.get_bead() == bead:
			return true
	return false

func set_bead_parent(bead: Bead) -> bool:
	for slot in bead_slots:
		if slot.add_bead(bead):
			bead.set_clickable(true)
			bead.clicked.connect(_on_bead_clicked.bind(bead))
			return true
	return false

func position_bead(bead: Bead):
	bead.travel_to(bead.get_parent().global_position, bead.global_scale, randf_range(0.0, 2*PI))

func get_beads() -> Array[Bead]:
	var cur_beads : Array[Bead]
	for slot in bead_slots:
		var bead = slot.get_bead()
		if is_instance_valid(bead) and not bead in cur_beads:
			cur_beads.append(bead)
	return cur_beads

func _on_bead_clicked(bead: Bead):
	if is_bead_in_container(bead):
		bead_clicked.emit(bead)
	else:
		bead.clicked.disconnect(_on_bead_clicked)

func get_bead_slots() -> Array[BeadSlot]:
	var slots: Array[BeadSlot]
	for child in bead_container.get_children():
		if child is BeadSlot:
			slots.append(child)
	return slots
