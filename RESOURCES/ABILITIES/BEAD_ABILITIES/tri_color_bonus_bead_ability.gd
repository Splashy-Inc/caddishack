extends BeadColorAbilityInfo

## Bonus points if bracelet contains all 3 colors
class_name TriColorBonusBeadAbility

@export var points_if_triggered := 1

## Generate [param points_if_triggered] if all 3 colors are in [param bead_info_set]
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> int:
	var bonus_points := 0
	
	if get_affected_beads(origin_bead_info, bead_info_set).size() == 3:
		bonus_points += points_if_triggered
	
	return bonus_points

func get_affected_beads(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> Array[BeadInfo]:
	var affected_beads : Array[BeadInfo]
	var unique_colors : Array[SandMaterialInfo.SandColor]
	if not origin_bead_info.sand.get_unique_colors().is_empty():
		for bead_info in bead_info_set:
			for color in bead_info.sand.get_unique_colors():
				if not color in unique_colors:
					unique_colors.append(color)
					affected_beads.append(bead_info)
	return affected_beads
