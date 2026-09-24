extends PanelContainer

class_name BraceletInfoPanel

@onready var points_number: Label = $VBoxContainer/HBoxContainer/ValueSection/PointsNumber
@onready var mult_number: Label = $VBoxContainer/HBoxContainer/ValueSection/MultNumber
@onready var value_number: Label = $VBoxContainer/HBoxContainer/VBoxContainer/ValueNumber
@onready var vouchers_number: Label = $VBoxContainer/HBoxContainer/VBoxContainer/VouchersNumber

var points := 0
var mult := 0
var value := 0
var vouchers := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoringEvents.bead_scored.connect(_on_bead_scored)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset():
	set_points(0)
	set_mult(0)
	set_value(0)
	set_vouchers(0)

func update_bracelet_info(bracelet: Bracelet):
	set_value(bracelet.calculate_value())
	set_points(bracelet.info.calculate_points())
	set_mult(bracelet.info.calculate_mult())
	set_vouchers(bracelet.info.calculate_vouchers())

func change_points(change : int):
	set_points(int(points_number.text) + change)
	set_value(points * mult)

func set_points(new_points : int):
	points = new_points
	points_number.text = str(points)
	
func change_mult(change : int):
	set_mult(int(mult_number.text) + change)
	set_value(points * mult)

func set_mult(new_mult : int):
	mult = new_mult
	mult_number.text = str(mult)
	
func change_value(change : int):
	set_value(int(value_number.text) + change)

func set_value(new_value : int):
	value_number.text = str(new_value)

func change_vouchers(change : int):
	set_vouchers(int(vouchers_number.text) + change)

func set_vouchers(new_vouchers : int):
	vouchers = new_vouchers
	vouchers_number.text = str(vouchers)

func _on_bead_scored(bead_points: int, bead_mult: int, vouchers: int):
	change_points(bead_points)
	change_mult(bead_mult)
	change_vouchers(vouchers)
