extends Station

class_name BraceletStation

@export var bead_pile: BeadArrayInfo

@onready var draw_pile: BeadPile = $PlayingField/DrawPile
@onready var discard_pile: BeadPile = $PlayingField/DiscardPile
@onready var hand_panel: BeadSet = $PlayingField/HandPanel
@onready var selection_panel: BeadSet = $PlayingField/SelectionPanel
@onready var bracelet_panel: BraceletContructionPanel = $PlayingField/BraceletPanel
@onready var complete_bracelet_panel: BraceletContainer = $PlayingField/CompleteBraceletPanel
@onready var info_panel: BraceletInfoPanel = $PlayingField/InfoPanel
@onready var discard_button: DiscardButton = $PlayingField/DiscardButton
@onready var play_button: Button = $PlayingField/PlayButton

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
	check_can_discard()

func get_beads_in_play() -> Array[Bead]:
	return selection_panel.get_beads() + hand_panel.get_beads()

func _on_hand_panel_bead_clicked(bead: Bead) -> void:
	selection_panel.add_bead(bead)
	check_can_play()
	check_can_discard()

func _on_selection_panel_bead_clicked(bead: Bead) -> void:
	hand_panel.add_bead(bead)
	check_can_play()
	check_can_discard()

func _on_play_pressed() -> void:
	play_selection()

func play_selection():
	for bead in selection_panel.get_beads():
		bracelet_panel.bracelet.add_bead(bead)
		await get_tree().create_timer(.1).timeout
		info_panel.update_bracelet_info(bracelet_panel.bracelet)
	
	if bracelet_panel.bracelet.is_complete():
		Globals.change_run_money(await bracelet_panel.bracelet.calculate_value(true))
		complete_bracelet_panel.add_bracelet(bracelet_panel.bracelet)
		Globals.run_info.bracelets = complete_bracelet_panel.get_bracelets_info()
		await get_tree().create_timer(1).timeout
		
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
	if check_can_discard():
		for bead in selection_panel.get_beads():
			discard_pile.add_bead(bead)
			await get_tree().create_timer(.05).timeout
		discard_button.use_discard()
		fill_hand()
	
	check_can_play()

func load_run_info():
	bracelet_panel.bracelet.clear_beads()
	selection_panel.clear_beads()
	hand_panel.clear_beads()
	discard_pile.clear_beads()
	draw_pile.set_beads(Globals.run_info.bead_pile)
	complete_bracelet_panel.fill_bracelets(Globals.run_info.bracelets)
	fill_hand()

func check_can_discard():
	if hand_panel.get_beads().size() + draw_pile.get_beads().size() < 10 - bracelet_panel.bracelet.get_beads().size():
		discard_button.disabled = true
		return false
	
	if discard_button.remaining <= 0:
		discard_button.disabled = true
		return false
	
	discard_button.disabled = false
	return true

func check_can_play():
	play_button.disabled = selection_panel.get_beads().size() > bracelet_panel.bracelet.get_open_slot_count()
