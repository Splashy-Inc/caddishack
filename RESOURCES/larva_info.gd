extends Resource

class_name LarvaInfo

@export var abilities : Array[AbilityInfo]
@export var base_abilities : Array[BaseAbilityInfo]
@export var name : String

const MAX_NUM_ABILITIES = 3

func add_ability(ability: AbilityInfo) -> bool:
	if ability is BaseAbilityInfo:
		base_abilities.append(ability.duplicate())
		return true
	else:
		if ability is PointsPleaseBeadAbility:
			var matching_abilities = ability.get_matching_abilities(abilities)
			if not matching_abilities.is_empty():
				return matching_abilities.front().change_stacks(1)
		
		if abilities.size() < MAX_NUM_ABILITIES and ability.can_apply_stack(abilities):
			var new_ability = ability.duplicate()
			if new_ability is PointsPleaseBeadAbility:
				new_ability.change_stacks(1)
			abilities.append(new_ability)
			return true
	return false
