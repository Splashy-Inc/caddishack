extends Station

class_name TerrariumStation

@export var round_length := 10

@onready var card_hand: CardHand = $CardSection/CardHand
@onready var terrarium: Terrarium = $Terrarium
@onready var lock_in_button: Button = $GameUISection/LockInButton
@onready var bead_scorer: Node2D = $BeadScorer

func _on_terrarium_larvae_done() -> void:
	if terrarium.get_beads().size() >= 10:
		print(terrarium.get_beads().size(), " beads")
	else:
		card_hand.draw_cards(7)

func _on_terrarium_larvae_started() -> void:
	card_hand.discard()

func _on_lock_in_button_pressed() -> void:
	terrarium.start_larvae(round_length)

func _on_terrarium_bead_limit_reached(full_terrarium: Terrarium) -> void:
	card_hand.hide()
	bead_scorer.show()
	bead_scorer.score_beads(full_terrarium.get_beads())
