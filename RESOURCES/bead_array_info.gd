extends Resource

class_name BeadArrayInfo

@export var beads : Array[BeadInfo]

func get_pile_stats() -> Dictionary:
	var bead_stats: Dictionary
	for bead in beads:
		var bead_type = Globals.MaterialColor.keys()[bead.color] + "_" + Globals.MaterialType.keys()[bead.special]
		if bead_type in bead_stats:
			bead_stats[bead_type] += 1
		else:
			bead_stats[bead_type] = 1
	return bead_stats

func get_beads() -> Array[BeadInfo]:
	return beads
