extends Resource

class_name BeadArrayInfo

@export var beads : Array[BeadInfo]

func get_pile_stats() -> Dictionary:
	var bead_stats: Dictionary
	for bead in beads:
		var bead_type = SandMaterialInfo.SandColor.keys()[bead.sand.color] + "_" + SpecialMaterialInfo.SpecialType.keys()[bead.special.type]
		if bead_type in bead_stats:
			bead_stats[bead_type] += 1
		else:
			bead_stats[bead_type] = 1
	return bead_stats

func get_beads() -> Array[BeadInfo]:
	return beads
