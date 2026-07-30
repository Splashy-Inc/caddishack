extends Node2D

class_name BeadScorer

signal beads_scored(score: int)

@onready var info_panel: BraceletInfoPanel = $InfoPanel
@onready var bracelet_panel: BraceletContructionPanel = $BraceletContructionPanel

var score := -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_beads(beads: Array[Bead]):
	reset()
	for bead in beads:
		if bracelet_panel.bracelet.add_bead(bead):
			#info_panel.update_bracelet_info(bracelet_panel.bracelet)
			await get_tree().create_timer(.1).timeout

func score_beads(beads: Array[Bead]):
	set_beads(beads)
	score = bracelet_panel.bracelet.calculate_value()
	beads_scored.emit(score)

func score_beads_animated(beads: Array[Bead]):
	await set_beads(beads)
	if not bracelet_panel.bracelet.animated_value_calculated.is_connected(_on_animated_value_calculated):
		bracelet_panel.bracelet.animated_value_calculated.connect(_on_animated_value_calculated)
	bracelet_panel.bracelet.calculate_value_animated()

func _on_animated_value_calculated(value: int):
	score = value
	beads_scored.emit(value)
	bracelet_panel.bracelet.animated_value_calculated.disconnect(_on_animated_value_calculated)

func reset():
	score = -1
	bracelet_panel.bracelet.clear_beads()
	info_panel.update_bracelet_info(bracelet_panel.bracelet)

func is_scoring_complete():
	return score >= 0
