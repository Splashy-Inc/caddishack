extends Resource

class_name AbilityInfo

@export var name : String
@export var description : String
@export var icon : Texture2D
@export var num_stacks := 0
@export var max_stacks := 1
var applied := false

func use_ability(input) -> Variant:
	return input

func apply_ability(application_target):
	_apply_ability()

func _apply_ability() -> bool:
	if not applied:
		applied = true
		return true
	
	return false

func change_stacks(change: int):
	num_stacks = clamp(num_stacks + change, 0, max_stacks)
