extends BeadCharmAbilityInfo

## Bonus mult equal to the points of this bead
class_name CharmCopycatBeadAbility

## Generate mult equal to the calculated points of [param origin_bead_info]
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> int:
	var bead_array_info := BeadArrayInfo.new()
	bead_array_info.beads = bead_info_set
	return origin_bead_info.calculate_points(bead_array_info)
