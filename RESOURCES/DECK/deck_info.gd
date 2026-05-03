extends Resource

class_name DeckInfo

@export var larvae : Array[LarvaInfo]

func get_sorted_larvae() -> Array[LarvaInfo]:
	var sorted_larvae := larvae
	sorted_larvae.sort_custom(sort_ability_count_descending)
	return sorted_larvae

func sort_ability_count_descending(a: LarvaInfo, b: LarvaInfo) -> bool:
	if a.abilities.size() > b.abilities.size():
		return true
	return false
