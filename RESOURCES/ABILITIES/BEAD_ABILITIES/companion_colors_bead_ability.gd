extends BeadColorAbilityInfo

## Bonus points for beads with the same color in bracelet
class_name CompanionColorsBeadAbility

@export var points_per_matching := 1

## Generate [param points_per_matching] for every bead in [param bead_info_set] containing
## a color matching a color in [param origin_bead_info]
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> int:
	var bonus_points := 0
	
	bonus_points += points_per_matching * get_affected_beads(origin_bead_info, bead_info_set).size()
	
	return bonus_points

func get_affected_beads(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> Array[BeadInfo]:
	var affected_beads : Array[BeadInfo]
	if origin_bead_info.sand.color != SandMaterialInfo.SandColor.COLORLESS:
		for bead_info in bead_info_set:
			if bead_info != origin_bead_info and bead_info.sand.color == origin_bead_info.sand.color:
				affected_beads.append(bead_info)
	return affected_beads
