extends Area2D

class_name CardHandler

var card : LarvaCard
var card_start_global_transform : Transform2D
var card_start_z : int
var card_start_parent : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardEvents.card_clicked.connect(_on_card_clicked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = global_position.lerp(get_viewport().get_mouse_position(), .5)
	if card:
		card.global_position = global_position

func _on_card_clicked(clicked_card: LarvaCard, button_index: MouseButton) -> void:
	if not is_instance_valid(card):
		if button_index == MOUSE_BUTTON_LEFT:
			#card_start_global_transform = clicked_card.global_transform
			#card_start_z = clicked_card.z_index
			#clicked_card.z_index = z_index
			card = clicked_card
			card_start_parent = card.get_parent()
			card.reparent(self, false)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT and card:
				if not card.drop():
					if card_start_parent.has_method("add_card"):
						card_start_parent.add_card(card)
					else:
						card.reparent(card_start_parent, false)
				#card.global_transform = card_start_global_transform
				#card.z_index = card_start_z
				card = null
