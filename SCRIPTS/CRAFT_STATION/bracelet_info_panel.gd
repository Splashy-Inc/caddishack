extends Control

class_name BraceletInfoPanel

@onready var points_number: Label = $CenteredPanel/VBoxContainer/GridContainer/PointsNumber
@onready var mult_number: Label = $CenteredPanel/VBoxContainer/GridContainer/MultNumber
@onready var value_number: Label = $CenteredPanel/VBoxContainer/GridContainer/ValueNumber

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_bracelet_info(bracelet: Bracelet):
	value_number.text = str(bracelet.calculate_value())
	points_number.text = str(bracelet.info.points)
	mult_number.text = str(bracelet.info.mult)
