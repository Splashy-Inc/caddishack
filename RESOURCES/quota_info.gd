extends Resource

class_name QuotaInfo

@export var max_rounds := 3
@export var rounds : Array[RoundInfo]
@export var quota := 100

func get_current_round_number() -> int:
	return rounds.size()

func get_current_round_info() -> RoundInfo:
	if not rounds.is_empty():
		return rounds.back()
	return null

func increment_round() -> bool:
	if rounds.size() < max_rounds:
		get_current_round_info().complete = true
		rounds.append(RoundInfo.new())
		return true
	return false

func load_from_info(new_info: QuotaInfo):
	if new_info != null:
		max_rounds = new_info.max_rounds
		rounds = new_info.rounds
		quota = new_info.quota
