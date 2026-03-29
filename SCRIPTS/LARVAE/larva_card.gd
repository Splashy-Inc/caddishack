extends Node2D

class_name LarvaCard

signal dropped
signal died

@onready var larva_slot: Node2D = $LarvaSlot
@onready var larva: Larva = $LarvaSlot/Larva
@onready var card: Node2D = $Card

var terrarium : Terrarium
var grabbed

func _process(delta: float) -> void:
	toggle_larva_view(is_instance_valid(terrarium))

func toggle_larva_view(is_larva: bool):
	if is_larva:
		larva.scale /= larva_slot.scale
		card.hide()
	else:
		larva.scale *= larva_slot.scale
		card.show()

func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		CardEvents.card_clicked.emit(self, event.button_index)

func get_larva() -> Larva:
	return larva

func drop():
	if terrarium:
		if terrarium.add_larva(larva):
			die()
			return
	
	dropped.emit(self)

func die():
	get_parent().remove_child(self)
	died.emit()

func _on_larva_slot_body_entered(body: Node2D) -> void:
	var body_parent = body.get_parent()
	if body_parent is Terrarium:
		terrarium = body_parent

func _on_larva_slot_body_exited(body: Node2D) -> void:
	if body.get_parent() == terrarium:
		terrarium = null
