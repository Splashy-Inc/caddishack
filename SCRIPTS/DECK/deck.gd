extends PanelContainer

class_name Deck

@onready var center: Node2D = $Center

const TOP_OFFSET = Vector2(-8,-8)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_draw_point_global() -> Vector2:
	return center.global_position + TOP_OFFSET

func add_card(card: LarvaCard):
	center.add_child(card)
