extends Station

class_name BraceletStation

@onready var draw_pile: BeadPile = $PlayingField/DrawPile
@onready var discard_pile: BeadPile = $PlayingField/DiscardPile
@onready var hand_panel: BeadSet = $PlayingField/HandPanel
@onready var selection_panel: BeadSet = $PlayingField/SelectionPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_hand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fill_hand():
	for i in (5 - get_beads_in_play().size()):
		var new_draw := draw_pile.draw_bead()
		print(new_draw)
		if new_draw:
			if not hand_panel.add_bead(new_draw):
				print("Failed to add bead to ", hand_panel)
		else:
			print("No more beads!")
		print(hand_panel.get_beads())
		await get_tree().create_timer(.05).timeout

func get_beads_in_play():
	return selection_panel.get_beads() + hand_panel.get_beads()

func _on_hand_panel_bead_clicked(bead: Bead) -> void:
	selection_panel.add_bead(bead)

func _on_selection_panel_bead_clicked(bead: Bead) -> void:
	hand_panel.add_bead(bead)

func _on_play_pressed() -> void:
	play_selection()

func play_selection():
	for bead in selection_panel.get_beads():
		bead.queue_free()
		await get_tree().create_timer(.05).timeout
	fill_hand()

func _on_discard_pressed() -> void:
	discard_selection()

func discard_selection():
	for bead in selection_panel.get_beads():
		discard_pile.add_bead(bead)
		await get_tree().create_timer(.05).timeout
	fill_hand()
