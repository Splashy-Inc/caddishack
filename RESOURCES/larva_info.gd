extends Resource

class_name LarvaInfo

@export var abilities : Array[AbilityInfo]

func add_ability(ability: AbilityInfo):
	if not ability in abilities:
		abilities.append(ability)
