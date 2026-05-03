extends Resource

class_name LarvaInfo

@export var abilities : Array[AbilityInfo]

const MAX_NUM_ABILITIES = 3

func add_ability(ability: AbilityInfo) -> bool:
	if abilities.size() < MAX_NUM_ABILITIES and not ability in abilities:
		abilities.append(ability.duplicate())
		return true
	
	return false
