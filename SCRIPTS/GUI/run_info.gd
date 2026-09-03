extends PanelContainer

class_name RunInfoPanel

signal number_change_complete

@onready var round_number: Label = $VBoxContainer/RoundNumber
@onready var quota_number: NumberLabel = $VBoxContainer/Quota/QuotaNumber
@onready var score_number: NumberLabel = $VBoxContainer/Score/ScoreNumber

var awaiting_quota_change = false
var awaiting_score_change = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RunEvents.round_updated.connect(set_round)
	RunEvents.quota_updated.connect(set_quota)
	RunEvents.score_updated.connect(set_score)
	quota_number.change_complete.connect(_on_quota_change_complete)
	score_number.change_complete.connect(_on_score_change_complete)
	
	set_round(RunEvents.get_round(), RunEvents.get_max_rounds())
	set_quota(RunEvents.get_quota(), 0.0)
	set_score(RunEvents.get_score(), 0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_round(current_round: int, max_rounds: int):
	round_number.text = str(current_round) + "/" + str(max_rounds)

func set_quota(current_quota: int, time : float = 2.0):
	if time > 0:
		awaiting_quota_change = true
	quota_number.set_number(current_quota, time)

func set_score(current_score: int, time : float = 2.0):
	if time > 0:
		awaiting_score_change = true
	score_number.set_number(current_score, time)

func _on_quota_change_complete():
	awaiting_quota_change = false
	if not (awaiting_quota_change or awaiting_score_change):
		number_change_complete.emit()

func _on_score_change_complete():
	awaiting_score_change = false
	if not (awaiting_quota_change or awaiting_score_change):
		number_change_complete.emit()
