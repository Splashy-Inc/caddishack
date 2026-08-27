extends UIButton

@export var cost := 50

func _button_ready() -> void:
	RunEvents.score_updated.connect(_on_score_updated)
	if RunEvents.get_quota():
		cost = int(RunEvents.get_quota() * .1)
	text = "Reroll Everything $" + str(cost)
	_on_score_updated(RunEvents.get_score())

func _on_score_updated(new_score):
	disabled = new_score < cost
