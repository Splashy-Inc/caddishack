extends Resource

class_name LarvaInfo

@export var abilities : Array[AbilityInfo]
@export var name : String

const MAX_NUM_ABILITIES = 3

func add_ability(ability: AbilityInfo) -> bool:
	if abilities.size() < MAX_NUM_ABILITIES and ability.can_apply_stack(abilities):
		abilities.append(ability.duplicate())
		return true
	
	return false
