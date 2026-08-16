extends Node2D

class_name CardHand

var cards : Array[LarvaCard]
var hand_width := 0.0
var hover_queue : Array[LarvaCard]

@onready var hand_region: CollisionShape2D = $HandRegion
@export var deck_info : DeckInfo
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var deck : Deck

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
	if spacing > hand_width/7:
		spacing = hand_width/7
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

func remove_card(card: LarvaCard, check_duck: bool = false) -> LarvaCard:
	if card in get_cards():
		remove_child(card)
		hover_queue.erase(card)
		card.unlift()
	else:
		card = null
	update_cards(check_duck)
	return card

func add_card(card: LarvaCard, check_duck: bool = true):
	if is_instance_valid(card.get_parent()):
		card.reparent(self, false)
	else:
		add_child(card)
	
	if card in cards:
		move_child(card, cards.find(card))
	else:
		move_child(card, hand_region.get_index())
	
	card.toggle_larva_view(false)
	if not card.dropped.is_connected(add_card):
			card.dropped.connect(add_card)
	if not card.died.is_connected(update_cards):
		card.died.connect(update_cards)
	if not card.hover_changed.is_connected(_on_card_hover_changed.bind(card)):
		card.hover_changed.connect(_on_card_hover_changed.bind(card))
	
	update_cards(check_duck)

func update_cards(check_duck: bool = true):
	cards = get_cards()
	space_cards()
	if check_duck:
		if cards.size() < 3:
			duck()
		else:
			unduck()

func draw_cards(num_cards: int):
	if num_cards > deck_info.larvae.size():
		num_cards = deck_info.larvae.size()
	
	for i in num_cards - get_cards().size():
		var draw_info = deck_info.larvae.pick_random()
		deck_info.larvae.erase(draw_info)
		var new_card = Globals.generate_card(draw_info)
		if deck:
			deck.add_card(new_card)
			new_card.global_position = deck.get_draw_point_global()
			await get_tree().create_timer(.1).timeout
		add_card(new_card, false)
		await get_tree().create_timer(.1).timeout
	update_cards()

func discard():
	for card in get_cards():
		remove_card(card)
		await get_tree().create_timer(.25).timeout

func duck():
	if position.y == 0:
		animation_player.play("duck")

func unduck():
	if position.y != 0 and get_cards().size() > 2:
		animation_player.play_backwards("duck")

func _on_card_hover_changed(is_hovered: bool, new_card: LarvaCard):
	if is_hovered and not new_card in hover_queue:
		hover_queue.append(new_card)
	else:
		new_card.unlift()
		hover_queue.erase(new_card)
	
	if hover_queue.size() == 1:
		hover_queue.front().lift()
	else:
		var hover_card : LarvaCard
		for card in cards:
			if is_instance_valid(card) and card in hover_queue and not card.is_larva_view():
				if not is_instance_valid(hover_card):
					hover_card = card
				# For now, we layer cards on top if they are further to the right
				elif card.global_position.x > hover_card.global_position.x:
					hover_card.unlift()
					hover_card = card
				else:
					card.unlift()
			elif is_instance_valid(card):
				card.unlift()
		
		if is_instance_valid(hover_card):
			hover_card.lift()
