extends BeadCharmAbilityInfo

## Bonus mult for each charm in largest matching set
class_name BigSetCharmsBeadAbility

@export var mult_per_charm := 1

## Generate mult equal to number of charms in largest set of matching charms in [param bead_info_set].
## Does not exclude origin bead, if in set.
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> int:
	return get_affected_beads(origin_bead_info, bead_info_set).size() * mult_per_charm

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
