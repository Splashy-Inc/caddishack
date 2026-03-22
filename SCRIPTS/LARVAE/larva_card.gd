extends Node2D

class_name LarvaCard

@onready var larva_slot: Node2D = $LarvaSlot
@onready var larva: Larva = $LarvaSlot/Larva
@onready var card: Node2D = $Card

func toggle_larva_view(is_larva: bool):
	if is_larva and card.visible:
		larva.global_position = global_position
		larva.scale /= larva_slot.scale
		card.hide()
	elif not card.visible:
		larva.position = Vector2.ZERO
		larva.scale *= larva_slot.scale
		card.show()

func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		CardEvents.card_clicked.emit(self, event.button_index)

func get_larva() -> Larva:
	return larva
