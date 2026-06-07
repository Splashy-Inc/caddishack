extends Button

@export var cost := 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RunEvents.score_updated.connect(_on_score_updated)
	text = "Reroll $" + str(cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_score_updated(new_score):
	disabled = new_score < cost
