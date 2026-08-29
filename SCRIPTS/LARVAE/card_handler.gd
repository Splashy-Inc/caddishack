extends Area2D

class_name CardHandler

@onready var click_window: Timer = $ClickWindow

var card : LarvaCard
var card_start_global_transform : Transform2D
var card_start_z : int
var card_start_parent : Node
var card_offset : Vector2

var drop_target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardEvents.card_pressed.connect(_on_card_pressed)

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

func _on_card_pressed(pressed_card: LarvaCard, button_index: MouseButton) -> void:
	if not is_instance_valid(card):
		if button_index == MOUSE_BUTTON_LEFT:
			card = pressed_card
			card_start_parent = card.get_parent()
			card.reparent(self, false)
			click_window.start()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT and card:
				if not click_window.is_stopped():
					CardEvents.card_clicked.emit(card, event.button_index)
					
				if not card.drop(drop_target):
					if not card.drop(card_start_parent):
						var card_container = get_tree().get_first_node_in_group("card_hand")
						if card_container is CardHand:
							card_container.add_card(card, true, true)
						else:
							card_container = get_tree().get_first_node_in_group("card_container")
							if card_container is DeckView:
								card_container.add_card(card, true)
							else:
								card.queue_free()
				
				if card_start_parent is CardHand:
					card_start_parent.update_cards()
				
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

# Indicates a card in being dragged
func _on_click_window_timeout() -> void:
	if card_start_parent is CardHand and is_instance_valid(card):
		card_start_parent.duck()
		card.draw_no_flip()
