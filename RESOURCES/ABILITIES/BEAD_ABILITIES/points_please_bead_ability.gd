extends BeadColorAbilityInfo

## Bonus points up to a limit
class_name PointsPleaseBeadAbility

@export var points_per_stack := 1

## Generate [param points_per_stack] points per stack
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> int:
	var bonus_points := 0
	
	bonus_points += points_per_stack * num_stacks
	
	return bonus_points

func can_apply_stack(abilities: Array):
	return num_stacks < max_stacks
