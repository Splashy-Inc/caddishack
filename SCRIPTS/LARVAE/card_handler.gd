extends Area2D

class_name CardHandler

var card : LarvaCard
var card_start_global_transform : Transform2D
var card_start_z : int
var card_start_parent : Node
var card_offset : Vector2

var drop_target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardEvents.card_clicked.connect(_on_card_clicked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = global_position.lerp(get_viewport().get_mouse_position(), .5)
	if card:
		card.toggle_larva_view(is_instance_valid(drop_target))
		if card.is_larva_view():
			card_offset = -card.larva_slot.position
		else:
			card_offset = Vector2.ZERO
		card.global_position = global_position + card_offset

func _on_card_clicked(clicked_card: LarvaCard, button_index: MouseButton) -> void:
	if not is_instance_valid(card):
		if button_index == MOUSE_BUTTON_LEFT:
			card = clicked_card
			card_start_parent = card.get_parent()
			if card_start_parent is CardHand:
				card_start_parent.duck()
			card.reparent(self, false)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT and card:
				if card_start_parent is CardHand:
					card_start_parent.unduck()
				if not card.drop(drop_target):
					if not card.drop(card_start_parent):
						var card_container = get_tree().get_first_node_in_group("card_hand")
						if card_container is CardHand:
							card_container.add_card(card)
						else:
							card_container = get_tree().get_first_node_in_group("card_container")
							if card_container is DeckView:
								card_container.add_card(card, true)
							else:
								card.queue_free()
				card = null

func _on_body_entered(body: Node2D) -> void:
	var body_parent = body.get_parent()
	if body_parent is Terrarium:
		drop_target = body_parent
	else:
		drop_target = body

func _on_body_exited(body: Node2D) -> void:
	if (body.get_parent() is Terrarium and body.get_parent() == drop_target) or body == drop_target:
		drop_target = null
