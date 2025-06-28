extends Station

class_name BraceletStation

@export var bead_pile: BeadArrayInfo

@onready var draw_pile: BeadPile = $PlayingField/DrawPile
@onready var discard_pile: BeadPile = $PlayingField/DiscardPile
@onready var hand_panel: BeadSet = $PlayingField/HandPanel
@onready var selection_panel: BeadSet = $PlayingField/SelectionPanel
@onready var bracelet_panel: BraceletContructionPanel = $PlayingField/BraceletPanel
@onready var complete_bracelet_panel: BraceletContainer = $PlayingField/CompleteBraceletPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if bead_pile:
		draw_pile.set_beads(bead_pile)
	fill_hand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fill_hand():
	for i in (5 - get_beads_in_play().size()):
		var new_draw := draw_pile.draw_bead()
		if new_draw:
			if not hand_panel.add_bead(new_draw):
				print("Failed to add bead to ", hand_panel)
		else:
			print("No more beads!")
		await get_tree().create_timer(.05).timeout

func get_beads_in_play():
	return selection_panel.get_beads() + hand_panel.get_beads()

func _on_hand_panel_bead_clicked(bead: Bead) -> void:
	if selection_panel.get_beads().size() < bracelet_panel.bracelet.get_open_slot_count():
		selection_panel.add_bead(bead)

func _on_selection_panel_bead_clicked(bead: Bead) -> void:
	hand_panel.add_bead(bead)

func _on_play_pressed() -> void:
	play_selection()

func play_selection():
	for bead in selection_panel.get_beads():
		bracelet_panel.bracelet.add_bead(bead)
		await get_tree().create_timer(.05).timeout
	
	if bracelet_panel.bracelet.is_complete():
		print("Bracelet completed!")
		print(bracelet_panel.bracelet.calculate_value())
		print(bracelet_panel.bracelet.info.points)
		print(bracelet_panel.bracelet.info.mult)
		print(bracelet_panel.bracelet.info.color_chains)
		print(bracelet_panel.bracelet.info.special_chains)
		
		await get_tree().create_timer(.5).timeout
		Globals.change_run_money(bracelet_panel.bracelet.calculate_value())
		complete_bracelet_panel.add_bracelet(bracelet_panel.bracelet)
		Globals.run_info.bracelets = complete_bracelet_panel.get_bracelets_info()
		await get_tree().create_timer(.5).timeout
		
		Globals.run_info.bead_pile.beads = []
		for bead in draw_pile.get_beads() + discard_pile.get_beads() + get_beads_in_play() :
			if bead is Bead:
				Globals.run_info.bead_pile.beads.append(bead.info)
		
		won.emit(self)
	else:
		fill_hand()

func _on_discard_pressed() -> void:
	discard_selection()

func discard_selection():
	for bead in selection_panel.get_beads():
		discard_pile.add_bead(bead)
		await get_tree().create_timer(.05).timeout
	fill_hand()

func load_run_info():
	bracelet_panel.bracelet.clear_beads()
	selection_panel.clear_beads()
	hand_panel.clear_beads()
	discard_pile.clear_beads()
	draw_pile.set_beads(Globals.run_info.bead_pile)
	complete_bracelet_panel.fill_bracelets(Globals.run_info.bracelets)
	fill_hand()
