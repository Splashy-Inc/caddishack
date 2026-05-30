extends Node

signal score_generated(score: int)
signal round_started
signal round_max_reached
signal quota_passed
signal quota_failed(old_run_info: RunInfo)

signal round_updated(new_current_round: int, new_max_rounds: int)
signal quota_updated(new_quota: int)
signal score_updated(new_score: int)

signal terrarium_info_updated(info: TerrariumInfo)

var run_info := RunInfo.new()
var cur_terrarium_info := preload("res://RESOURCES/new_terrarium.tres")

var new_run_info := preload("res://RESOURCES/new_run.tres")
var test_run_info := preload("res://RESOURCES/test_run.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_generated.connect(change_score)
	round_started.connect(increment_round)
	load_run_info(test_run_info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_max_rounds() -> int:
	return run_info.max_rounds

func set_round(new_current_round: int, new_max_rounds: int = get_max_rounds()):
	run_info.cur_round = new_current_round
	run_info.max_rounds = new_max_rounds
	round_updated.emit(run_info.cur_round, run_info.max_rounds)

func get_round() -> int:
	return run_info.cur_round

func increment_round() -> bool:
	if run_info.cur_round < run_info.max_rounds:
		set_round(run_info.cur_round + 1, run_info.max_rounds)
		return true
	else:
		round_max_reached.emit()
		return false

func set_quota(new_quota: int):
	run_info.cur_quota = new_quota
	quota_updated.emit(run_info.cur_quota)

func get_quota() -> int:
	return run_info.cur_quota

func change_quota(change: int):
	set_quota(run_info.cur_quota + change)

func set_score(new_score: int):
	run_info.score = new_score
	score_updated.emit(run_info.score)

func get_score() -> int:
	return run_info.score

func change_score(change: int):
	set_score(run_info.score + change)

func reset_run():
	load_run_info(new_run_info.duplicate(true))

func load_run_info(loaded_run_info: RunInfo):
	set_round(loaded_run_info.cur_round, loaded_run_info.max_rounds)
	set_quota(loaded_run_info.cur_quota)
	set_score(loaded_run_info.score)
	set_deck_info(loaded_run_info.deck)

func set_current_terrarium_info(new_info: TerrariumInfo):
	cur_terrarium_info = new_info
	terrarium_info_updated.emit(cur_terrarium_info)

func get_current_terrarium_info() -> TerrariumInfo:
	return cur_terrarium_info

func set_deck_info(new_deck: DeckInfo):
	run_info.deck = new_deck.duplicate(true)
	var default_names = get_names().duplicate(true)
	for larva in run_info.deck.larvae:
		if larva.name == "" and not default_names.is_empty():
			var new_name = default_names.pick_random()
			larva.name = new_name
			default_names.erase(new_name)

func get_current_deck_info() -> DeckInfo:
	return run_info.deck

func is_final_round() -> bool:
	return get_round() >= get_max_rounds()

func check_quota() -> bool:
	if get_score() < get_quota():
		quota_failed.emit(run_info.duplicate(true))
		return false
	else:
		quota_passed.emit()
		return true

func get_names():
	return run_info.default_names
