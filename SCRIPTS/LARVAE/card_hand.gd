extends Node2D

class_name CardHand

var cards : Array[LarvaCard]
var hand_width := 0.0

@onready var hand_region: CollisionShape2D = $HandRegion
@export var deck_info : DeckInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_width = hand_region.shape.get_rect().size.x
	deck_info = RunEvents.get_current_deck_info().duplicate(true)
	draw_cards(7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func space_cards():
	var num_cards = cards.size()
	var spacing = hand_width/num_cards
	var middle = num_cards/2.0 - .5
	for i in num_cards:
		var card = cards.get(i)
		card.position.x = 0 - spacing * (middle - i)
		card.global_position.y = global_position.y

func get_cards() -> Array[LarvaCard]:
	var card_array : Array[LarvaCard]
	for node in get_children():
		if node is LarvaCard:
			card_array.append(node)
	
	return card_array

func remove_card(card: LarvaCard) -> LarvaCard:
	if card in get_cards():
		remove_child(card)
	else:
		card = null
	update_cards()
	return card

func add_card(card: LarvaCard):
	if is_instance_valid(card.get_parent()):
		card.reparent(self)
	else:
		add_child(card)
	
	update_cards()

func update_cards():
	cards = get_cards()
	space_cards()

func draw_cards(num_cards: int):
	if num_cards > deck_info.larvae.size():
		num_cards = deck_info.larvae.size()
	
	for i in num_cards - get_cards().size():
		var draw_info = deck_info.larvae.pick_random()
		deck_info.larvae.erase(draw_info)
		var new_card = Globals.generate_card(draw_info)
		add_child(new_card)
		if not new_card.dropped.is_connected(add_card):
			new_card.dropped.connect(add_card)
		if not new_card.died.is_connected(update_cards):
			new_card.died.connect(update_cards)
	update_cards()

func discard():
	for card in get_cards():
		card.queue_free()
		await get_tree().create_timer(.25).timeout
