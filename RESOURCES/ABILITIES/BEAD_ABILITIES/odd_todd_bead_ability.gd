extends BeadColorAbilityInfo

## Bonus points if beads in bracelet with matching color are odd
class_name OddToddBeadAbility

@export var points_if_triggered := 1

## Generate [param points_if_triggered] if there are an odd number of beads in [param bead_info_set]
## with a color matching that in [param origin_bead_info]
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> int:
	var bonus_points := 0
	
	if get_affected_beads(origin_bead_info, bead_info_set).size() % 2 == 1:
		bonus_points += points_if_triggered
	
	return bonus_points

func get_affected_beads(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> Array[BeadInfo]:
	var affected_beads : Array[BeadInfo]
	if not origin_bead_info.sand.get_unique_colors().is_empty():
		for bead_info in bead_info_set:
			if bead_info.sand.has_matching_color(origin_bead_info.sand):
				affected_beads.append(bead_info)
	return affected_beads
