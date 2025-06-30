extends CanvasLayer

class_name StationUI

@export var terrarium_ui: Control
@onready var materials_out_label: Label = $TerrariumUI/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terrarium_ui.visible = get_parent() is TerrariumStation
	materials_out_label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
