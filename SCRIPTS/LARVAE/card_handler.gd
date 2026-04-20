extends Area2D

class_name CardHandler

var card : LarvaCard
var card_start_position : Vector2

var terrarium : Terrarium

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
			card = clicked_card

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT and card:
				if terrarium:
					if terrarium.add_larva(card.get_larva()):
						card.queue_free()
						card = null
						return
				
				card.drop()
				card = null
