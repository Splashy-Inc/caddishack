extends BeadAbilityInfo

class_name BaseAbilityInfo

## Base Abilities return a multiplier, instead of an additive bonus to points or mult
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]):
	return 0

func get_affected_beads(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> Array[BeadInfo]:
	return [origin_bead_info]
