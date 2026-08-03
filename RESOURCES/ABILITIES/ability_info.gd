extends Resource

class_name AbilityInfo

@export var name : String
@export var description : String
@export var icon : Texture2D
@export var active_icon : Texture2D
@export var num_stacks := 0
@export var max_stacks := 3
var applied := false

func use_ability(origin, target):
	return null

func apply_ability(application_target):
	_apply_ability()

func _apply_ability() -> bool:
	if not applied:
		applied = true
		return true
	
	return false

func change_stacks(change: int) -> bool:
	var new_stacks = num_stacks + change
	
	if new_stacks > max_stacks:
		return false
	
	num_stacks = clamp(new_stacks, 0, max_stacks)
	return true

func get_matching_abilities(abilities: Array) -> Array:
	var matching_abilities : Array
	for ability in abilities:
		if ability is AlwaysColorBeadAbility and self is AlwaysColorBeadAbility:
			matching_abilities.append(ability)
		elif ability is AbilityInfo:
			if ability.name == name:
				matching_abilities.append(ability)
	return matching_abilities

func can_apply_stack(abilities: Array):
	return get_matching_abilities(abilities).size() < max_stacks
