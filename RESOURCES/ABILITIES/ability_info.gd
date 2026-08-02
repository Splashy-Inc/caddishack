extends Resource

class_name AbilityInfo

@export var name : String
@export var description : String
@export var icon : Texture2D
@export var active_icon : Texture2D
@export var num_stacks := 0
@export var max_stacks := 1
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
