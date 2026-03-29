extends PanelContainer

@onready var round_number: Label = $VBoxContainer/RoundNumber
@onready var quota_number: Label = $VBoxContainer/QuotaNumber
@onready var score_number: Label = $VBoxContainer/ScoreNumber

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RunEvents.round_updated.connect(set_round)
	RunEvents.quota_updated.connect(set_quota)
	RunEvents.score_updated.connect(set_score)
	
	set_round(RunEvents.current_round, RunEvents.max_rounds)
	set_quota(RunEvents.quota)
	set_score(RunEvents.score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_round(current_round: int, max_rounds: int):
	round_number.text = str(current_round) + "/" + str(max_rounds)

func set_quota(current_quota: int):
	quota_number.text = str(current_quota)

func set_score(current_score: int):
	score_number.text = str(current_score)
