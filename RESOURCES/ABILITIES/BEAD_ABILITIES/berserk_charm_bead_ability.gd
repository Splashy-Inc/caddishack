extends BeadCharmAbilityInfo

## Random bonus mult between min and max
class_name BerserkCharmBeadAbility

@export var min_mult := 0
@export var max_mult := 10

## Generate mult between [param min_mult] and [param max_mult].
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> int:
	return randi_range(min_mult, max_mult)
