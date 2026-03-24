extends Station

class_name TerrariumStation

@onready var card_hand: CardHand = $PlayScreen/CardSection/CardHand

func _on_terrarium_larvae_done() -> void:
	card_hand.draw_cards(7)
