extends Resource

class_name BraceletInfo

@export var bead_array_info := BeadArrayInfo.new()

const POINTS_BASE := 0
const MULT_BASE := 0

var points := POINTS_BASE
var mult := MULT_BASE
var value := 0

func calculate_points() -> int:
	points = POINTS_BASE
	
	for bead in bead_array_info.get_beads():
		points += bead.calculate_points(bead_array_info)
	
	return points

func calculate_mult() -> int:
	mult = MULT_BASE
	
	for bead in bead_array_info.get_beads():
		mult += bead.calculate_mult(bead_array_info)
	
	return mult

func calculate_value() -> int:
	points = calculate_points()
	mult = calculate_mult()
	value = points * mult
	return value

func get_bead_array_info() -> BeadArrayInfo:
	return bead_array_info

func set_bead_array_info(new_info):
	bead_array_info = new_info
