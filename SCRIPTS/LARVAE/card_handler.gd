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
	var old_pos = global_position
	global_position = global_position.lerp(get_viewport().get_mouse_position(), .5)
	if old_pos.distance_to(global_position) > 10:
		start_drag()
	if card and card.get_parent() == self:
		card.toggle_larva_view(is_instance_valid(drop_target))
		if card.is_larva_view():
			card_offset = -card.larva_slot.position
			if global_position.distance_to(old_pos) > 1:
				rotation = lerpf(rotation, old_pos.angle_to_point(global_position), .5)
		else:
			card_offset = Vector2.ZERO
			rotation = 0
		card.position = card_offset
	

func _on_card_pressed(pressed_card: LarvaCard, button_index: MouseButton) -> void:
	if not is_instance_valid(card):
		if button_index == MOUSE_BUTTON_LEFT:
			card = pressed_card
			card_start_parent = card.get_parent()
			click_window.start()
			
			if not card.is_larva_view():
				card.draw_no_flip()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT and card:
				if not click_window.is_stopped():
					CardEvents.card_clicked.emit(card, event.button_index)
				else:
					if not card.drop(drop_target):
						if not card.drop(card_start_parent):
							var card_container = get_tree().get_first_node_in_group("card_hand")
							if card_container is CardHand:
								card_container.add_card(card, true, true)
								card.draw_no_flip()
							else:
								card_container = get_tree().get_first_node_in_group("card_container")
								if card_container is DeckView:
									card_container.add_card(card, true)
									card.draw_no_flip()
								else:
									card.queue_free()
					else:
						card.larva.collect_sound.play()
					
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
	start_drag()

func start_drag():
	click_window.stop()
	if is_instance_valid(card):
		card.reparent(self, true)
		card.rotation = 0
		if card_start_parent is CardHand:
			card_start_parent.duck()
		CardEvents.card_drag_started.emit(card)
