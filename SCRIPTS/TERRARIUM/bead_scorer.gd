extends Node2D

class_name BeadScorer

signal beads_scored(score: int)

@onready var info_panel: BraceletInfoPanel = $InfoPanel
@onready var bracelet_panel: BraceletContructionPanel = $BraceletContructionPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func score_beads(beads: Array[Bead]):
	for bead in beads:
		bracelet_panel.bracelet.add_bead(bead)
		info_panel.update_bracelet_info(bracelet_panel.bracelet)
		await get_tree().create_timer(.1).timeout
	print(bracelet_panel.bracelet.calculate_value())
	beads_scored.emit(bracelet_panel.bracelet.calculate_value())
