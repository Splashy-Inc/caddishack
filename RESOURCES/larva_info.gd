extends Resource

class_name LarvaInfo

@export var abilities : Array[AbilityInfo]
@export var name : String

const MAX_NUM_ABILITIES = 3

func add_ability(ability: AbilityInfo) -> bool:
	if ability in abilities:
		if ability.change_stacks(1):
			return true
	elif abilities.size() < MAX_NUM_ABILITIES:
		abilities.append(ability.duplicate())
		return true
	
	return false
