extends Resource

class_name BeadArrayInfo

@export var beads : Array[BeadInfo]

func get_beads() -> Array[BeadInfo]:
	return beads

func load_from_bead_array(bead_array: Array[Bead]):
	beads.clear()
	for bead in bead_array:
		beads.append(bead.info)
