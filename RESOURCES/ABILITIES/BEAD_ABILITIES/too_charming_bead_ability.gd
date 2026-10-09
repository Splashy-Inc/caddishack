extends BeadCharmAbilityInfo

## Bonus mult for largest set of matching charms in bracelet, 0 bonus mult if too many
## Lots of mult if just right
class_name TooCharmingBeadAbility

## Key is number charm types, value is bonus mult
@export var mult_bonus_tiers : Dictionary[int, int]

## Generate mult depending on how many charms are in the largest set in [param bead_info_set].
## Includes origin bead, if in set. Assumes [param mult_bonus_tier] is sorted smallest to largest
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> int:
	var bonus_mult := 0
	
	# TODO: Add function to sort dictionary by key, smallest to largest
	for tier in mult_bonus_tiers.keys():
		if get_affected_beads(origin_bead_info, bead_info_set).size() >= tier:
			bonus_mult = mult_bonus_tiers[tier]
	
	return bonus_mult

func get_affected_beads(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> Array[BeadInfo]:
	var affected_beads : Array[BeadInfo]
	var charm_type_sets : Dictionary[SpecialMaterialInfo.SpecialType, Array]
	
	for bead_info in bead_info_set:
		match bead_info.special.type:
			null:
				pass
			SpecialMaterialInfo.SpecialType.BASIC:
				pass
			_:
				if not charm_type_sets.has(bead_info.special.type):
					charm_type_sets.set(bead_info.special.type, [] as Array[BeadInfo])
				charm_type_sets[bead_info.special.type].append(bead_info)

	for charm_type in charm_type_sets.keys():
		if affected_beads.size() == 0:
			affected_beads = charm_type_sets[charm_type]
		elif affected_beads.size() < charm_type_sets[charm_type].size():
			affected_beads = charm_type_sets[charm_type]

	return affected_beads
