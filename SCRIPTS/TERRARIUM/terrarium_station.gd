extends Station

class_name TerrariumStation

@export var round_length := 10

@onready var card_hand: CardHand = $CardSection/CardHand
@onready var terrarium: Terrarium = $Terrarium
@onready var bead_scorer: BeadScorer = $BeadScorer
@onready var terrarium_scoring_slot: Marker2D = $TerrariumScoringSlot
@onready var terrarium_play_slot: Marker2D = $TerrariumPlaySlot

func _ready() -> void:
	terrarium.travel_to(terrarium_play_slot.transform)
	load_run_info()

func _on_terrarium_larvae_done() -> void:
	if terrarium.get_beads().size() >= 10:
		print(terrarium.get_beads().size(), " beads")
	else:
		card_hand.draw_cards(7)

func _on_terrarium_larvae_started() -> void:
	card_hand.discard()

func _on_next_button_pressed() -> void:
	if bead_scorer.is_scoring_complete():
		ScreenEvents.request_screen(ScreenEvents.Screen.SHOP)
	else:
		terrarium.start_larvae(round_length)

func _on_terrarium_bead_limit_reached(full_terrarium: Terrarium) -> void:
	card_hand.hide()
	terrarium.travel_to(terrarium_scoring_slot.transform)
	bead_scorer.show()
	bead_scorer.score_beads(full_terrarium.get_beads())

func _on_bead_scorer_beads_scored(score: int) -> void:
	RunEvents.score_generated.emit(score)

func load_run_info():
	terrarium.initialize(RunEvents.get_current_terrarium_info())
