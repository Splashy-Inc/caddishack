extends Node2D

class_name BeadScorer

signal beads_scored(score: int)
signal scoring_finished

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
		if bracelet_panel.bracelet.add_bead(bead):
			info_panel.update_bracelet_info(bracelet_panel.bracelet)
			await get_tree().create_timer(.1).timeout
	var new_score = bracelet_panel.bracelet.calculate_value()
	beads_scored.emit(new_score)
	
func reset():
	bracelet_panel.bracelet.clear_beads()
	info_panel.update_bracelet_info(bracelet_panel.bracelet)

func _on_continue_button_pressed() -> void:
	scoring_finished.emit()
