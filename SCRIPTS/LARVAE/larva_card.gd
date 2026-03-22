extends Node2D

var grabbed := false
var original_position : Vector2

@onready var larva_slot: Node2D = $LarvaSlot
@onready var larva: Larva = $LarvaSlot/Larva
@onready var card: Node2D = $Card

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grabbed:
		global_position = get_viewport().get_mouse_position()
		if global_position.distance_to(original_position) > 64:
			if card.visible:
				larva.global_position = global_position
				larva.scale /= larva_slot.scale
				card.hide()
		elif not card.visible:
			larva.position = Vector2.ZERO
			larva.scale *= larva_slot.scale
			card.show()

func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouse and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			toggle_grabbed(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		if event.button_index == MOUSE_BUTTON_LEFT and grabbed:
			toggle_grabbed(false)
			
func toggle_grabbed(is_grabbed: bool):
	grabbed = is_grabbed
	if not grabbed:
		global_position = original_position
		larva.position = Vector2.ZERO
		larva.scale *= larva_slot.scale
		card.show()
