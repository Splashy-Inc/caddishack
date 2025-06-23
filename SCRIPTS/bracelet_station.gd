extends Node

class_name BraceletStation

@onready var draw_pile: BeadPile = $PlayingField/DrawPile
@onready var discard_pile: BeadPile = $PlayingField/DiscardPile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO: Remove this since it's just used for testing the draw pile
func _on_button_pressed() -> void:
	var new_draw := draw_pile.draw_bead()
	print(new_draw)
	if new_draw:
		discard_pile.add_bead(new_draw)
	else:
		print("No more beads!")
