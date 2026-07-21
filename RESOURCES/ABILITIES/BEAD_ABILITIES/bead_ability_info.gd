extends AbilityInfo

class_name BeadAbilityInfo

func apply_ability(application_target: Bead):
	_apply_ability()

func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]):
	return 0

func get_affected_beads(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> Array[BeadInfo]:
	return []

func _find_in_set(beads: Array[Bead]) -> Bead:
	for bead in beads:
		if self in bead.info.abilities:
			return bead
	return null
