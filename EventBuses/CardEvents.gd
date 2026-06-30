extends Node

signal card_pressed(larva_card: LarvaCard, button_index: MouseButton)
signal card_released(larva_card: LarvaCard, button_index: MouseButton)
signal card_clicked(larva_card: LarvaCard, button_index: MouseButton)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
