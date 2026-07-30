extends BeadCharmAbilityInfo

## Bonus mult for number of different charms in bracelet, 0 bonus mult if too many
class_name TooCharmingBeadAbility

## Key is number charm types, value is bonus mult
@export var mult_bonus_tiers : Dictionary[int, int]

## Generate mult depending on how many different charm types are in [param bead_info_set].
## Does not exclude origin bead, if in set. Assumes [param mult_bonus_tier] it sorted smallest to largest
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> int:
	var bonus_mult := 0
	
	# TODO: Add function to sort dictionary by key, smallest to largest
	for tier in mult_bonus_tiers.keys():
		if get_affected_beads(origin_bead_info, bead_info_set).size() >= tier:
			bonus_mult = mult_bonus_tiers[tier]
	
	return bonus_mult

func get_affected_beads(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> Array[BeadInfo]:
	var affected_beads : Array[BeadInfo]
	var charm_types : Array[SpecialMaterialInfo.SpecialType]
	
	for bead_info in bead_info_set:
		match bead_info.special.type:
			null:
				pass
			SpecialMaterialInfo.SpecialType.BASIC:
				pass
			_:
				if not charm_types.has(bead_info.special.type):
					charm_types.append(bead_info.special.type)
					affected_beads.append(bead_info)

	return affected_beads
