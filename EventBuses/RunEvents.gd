extends Node

signal score_generated(score: int)
signal round_started
signal round_max_reached

signal round_updated(new_current_round: int, new_max_rounds: int)
signal quota_updated(new_quota: int)
signal score_updated(new_score: int)

signal terrarium_info_updated(info: TerrariumInfo)

var current_round := 0
var max_rounds := 3
var quota := 100
var score := 400
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

# TODO: All the below
func set_round(new_current_round: int, new_max_rounds: int):
	current_round = new_current_round
	max_rounds = new_max_rounds
	round_updated.emit(current_round, max_rounds)

func increment_round() -> bool:
	if current_round < max_rounds:
		set_round(current_round + 1, max_rounds)
		return true
	else:
		round_max_reached.emit()
		return false

func set_quota(new_quota: int):
	quota = new_quota
	quota_updated.emit(quota)

func set_score(new_score: int):
	score = new_score
	score_updated.emit(score)

func change_score(change: int):
	set_score(score + change)

func reset_run():
	load_run_info(new_run_info)

func load_run_info(run_info: RunInfo):
	set_round(run_info.cur_round, run_info.max_rounds)
	set_quota(run_info.cur_quota)
	set_score(run_info.score)

func set_current_terrarium_info(new_info: TerrariumInfo):
	cur_terrarium_info = new_info
	terrarium_info_updated.emit(cur_terrarium_info)

func get_current_terrarium_info() -> TerrariumInfo:
	return cur_terrarium_info
