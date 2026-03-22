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
	global_position = get_viewport().get_mouse_position()
	
	if card:
		card.global_position = card.global_position.lerp(global_position, .5)

func _on_card_clicked(clicked_card: LarvaCard, button_index: MouseButton) -> void:
	if not is_instance_valid(card):
		if button_index == MOUSE_BUTTON_LEFT:
			card = clicked_card
			card_start_position = card.global_position
			card.toggle_larva_view(true)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT and card:
				if terrarium:
					if terrarium.add_larva(card.get_larva()):
						card.queue_free()
						card = null
						return
				
				card.global_position = card_start_position
				card.toggle_larva_view(false)
				card = null

func _on_body_entered(body: Node2D) -> void:
	var body_parent = body.get_parent()
	if body_parent is Terrarium:
		terrarium = body_parent

func _on_body_exited(body: Node2D) -> void:
	terrarium = null
